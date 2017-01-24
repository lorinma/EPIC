DROP TABLE IF EXISTS trade CASCADE;
CREATE TABLE IF NOT EXISTS trade (
  name CHAR(20) PRIMARY KEY NOT NULL UNIQUE
);

DROP TABLE IF EXISTS work_method CASCADE;
CREATE TABLE IF NOT EXISTS work_method (
  trade_name   CHAR(20) REFERENCES trade (name) ON DELETE CASCADE,
  method       CHAR(50) PRIMARY KEY NOT NULL UNIQUE,
  productivity REAL                 NOT NULL
);

DROP TABLE IF EXISTS work_method_dependency CASCADE;
CREATE TABLE IF NOT EXISTS work_method_dependency (
  predecessor CHAR(50) REFERENCES work_method (method) ON DELETE CASCADE,
  successor   CHAR(50) REFERENCES work_method (method) ON DELETE CASCADE,
  PRIMARY KEY (predecessor, successor)
);

DROP TABLE IF EXISTS space CASCADE;
CREATE TABLE IF NOT EXISTS space (
  name INTEGER PRIMARY KEY NOT NULL UNIQUE
);

DROP TABLE IF EXISTS design CASCADE;
CREATE TABLE IF NOT EXISTS Design (
  work_method CHAR(50) REFERENCES work_method (method) ON DELETE CASCADE,
  space       INTEGER REFERENCES space (name) ON DELETE CASCADE,
  quantity    REAL NOT NULL,
  PRIMARY KEY (work_method, space)
);

DROP TABLE IF EXISTS workflow CASCADE;
CREATE TABLE IF NOT EXISTS Workflow (
  id                 SERIAL PRIMARY KEY,
  work_method        CHAR(50) REFERENCES work_method (method) ON DELETE CASCADE,
  space              INTEGER REFERENCES space (name) ON DELETE CASCADE,
  remaining_quantity REAL NOT NULL,
  day                INTEGER DEFAULT 0
);
