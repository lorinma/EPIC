DROP VIEW IF EXISTS work_incomplete CASCADE;
CREATE VIEW work_incomplete AS
  SELECT
    incomplete.work_method,
    incomplete.space,
    incomplete.remaining_quantity,
    incomplete.id
  FROM (
         SELECT
           work_method,
           space,
           remaining_quantity,
           id,
           max(id)
           OVER (PARTITION BY work_method, space) max_id
         FROM workflow) incomplete
  WHERE id = max_id AND remaining_quantity > 0;

DROP VIEW IF EXISTS work_in_progress CASCADE;
CREATE VIEW work_in_progress AS
  SELECT
    work_incomplete.work_method,
    work_incomplete.space,
    work_incomplete.id
  FROM work_incomplete
    LEFT JOIN design
      ON work_incomplete.work_method = design.work_method AND work_incomplete.space = design.space
  WHERE design.quantity > work_incomplete.remaining_quantity;

DROP VIEW IF EXISTS work_not_begin CASCADE;
CREATE VIEW work_not_begin AS
  SELECT
    work_incomplete.work_method,
    work_incomplete.space,
    work_incomplete.id
  FROM work_incomplete
    LEFT JOIN design
      ON work_incomplete.work_method = design.work_method AND work_incomplete.space = design.space
  WHERE design.quantity = work_incomplete.remaining_quantity;

DROP VIEW IF EXISTS project_complete CASCADE;
CREATE VIEW project_complete AS
  SELECT count(*) = 0 complete
  FROM work_incomplete;

DROP VIEW IF EXISTS today CASCADE;
CREATE VIEW today AS
  SELECT max(day) AS day
  FROM workflow;

DROP VIEW IF EXISTS mature_work CASCADE;
CREATE VIEW mature_work AS
  SELECT
    temp2.work_method,
    temp2.space,
    temp2.id,
    work_method.trade_name,
    work_method.productivity
  FROM (
         SELECT
           *,
           sum(remaing_quantity)
           OVER (PARTITION BY work_method, space, id) quantity_new
         FROM (
                SELECT
                  work_incomplete.work_method    work_method,
                  work_incomplete.space          space,
                  work_incomplete.id,
                  predecessor.remaining_quantity remaing_quantity
                FROM work_incomplete
                  LEFT JOIN work_method_dependency ON work_incomplete.work_method = work_method_dependency.successor
                  LEFT JOIN work_incomplete predecessor
                    ON work_method_dependency.predecessor = predecessor.work_method AND
                       work_incomplete.space = predecessor.space) temp
       ) temp2
    LEFT JOIN work_method ON temp2.work_method = work_method.method
  WHERE quantity_new IS NULL;

DROP VIEW IF EXISTS chose_work CASCADE;
CREATE VIEW chose_work AS
  SELECT
    work_incomplete.work_method,
    work_incomplete.space,
    mature.productivity,
    work_incomplete.remaining_quantity
  FROM (
         SELECT
           work_method,
           space,
           productivity,
           trade_name,
           id,
           max(id)
           OVER (PARTITION BY trade_name) max_id
         FROM mature_work
       ) mature INNER JOIN work_incomplete ON max_id = work_incomplete.id;

DROP VIEW IF EXISTS launch_work CASCADE;
CREATE VIEW launch_work AS
  SELECT
    chose_work.work_method,
    chose_work.space,
    chose_work.remaining_quantity remaining_quantity,
    day AS                        day
  FROM chose_work
    INNER JOIN work_not_begin
      ON chose_work.work_method = work_not_begin.work_method AND chose_work.space = work_not_begin.space
    CROSS JOIN today;

DROP VIEW IF EXISTS after_work CASCADE;
CREATE VIEW after_work AS
  SELECT
    chose_work.work_method,
    chose_work.space,
    greatest(chose_work.remaining_quantity - chose_work.productivity, 0) AS remaining_quantity,
    day + 1                                                              AS day
  FROM chose_work
    CROSS JOIN today;

DROP VIEW IF EXISTS result CASCADE;
CREATE VIEW result AS
  SELECT
    work_method.trade_name,
    workflow.work_method,
    workflow.space,
    workflow.day,
    (design.quantity - remaining_quantity) / design.quantity + design.space - 1 finished
  FROM workflow
    LEFT JOIN design ON workflow.work_method = design.work_method AND workflow.space = design.space
    LEFT JOIN work_method ON workflow.work_method = work_method.method
  WHERE workflow.id > (SELECT count(*)
                       FROM design)
  ORDER BY work_method.trade_name, workflow.work_method, workflow.day;