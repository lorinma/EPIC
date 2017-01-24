CREATE OR REPLACE FUNCTION one_day_work()
  RETURNS BOOLEAN AS $complete$
DECLARE
  result BOOLEAN;
BEGIN
  INSERT INTO workflow (work_method, space, remaining_quantity, day)
    SELECT *
    FROM launch_work;
  INSERT INTO workflow (work_method, space, remaining_quantity, day)
    SELECT *
    FROM after_work;
  SELECT complete
  INTO result
  FROM project_complete;
  RETURN result;
END;
$complete$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION run_project()
  RETURNS VOID AS $$
BEGIN
  WHILE NOT one_day_work() LOOP
  END LOOP;
END;
$$ LANGUAGE plpgsql;