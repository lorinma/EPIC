DROP VIEW IF EXISTS work_incomplete CASCADE;
CREATE VIEW work_incomplete AS
  SELECT
    work_method,
    space,
    remaining_quantity,
    id
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
    work_incomplete.work_method,
    work_incomplete.space,
    work_incomplete.id,
    work_method.productivity,
    work_method.trade_name
  FROM work_incomplete
    LEFT JOIN work_method_dependency ON work_incomplete.work_method = work_method_dependency.successor
    LEFT JOIN work_incomplete predecessor
      ON work_method_dependency.predecessor = predecessor.work_method AND work_incomplete.space = predecessor.space
    LEFT JOIN work_method ON work_incomplete.work_method = work_method.method
  WHERE predecessor.work_method IS NULL;

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

DROP VIEW IF EXISTS after_work CASCADE;
CREATE VIEW after_work AS
  SELECT
    chose_work.work_method,
    chose_work.space,
    chose_work.remaining_quantity - chose_work.productivity AS remaining_quantity,
    day + 1                                                 AS day
  FROM chose_work
    CROSS JOIN today;

