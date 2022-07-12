CREATE TABLE tests (
  id serial PRIMARY KEY,
  name text NOT NULL UNIQUE,
  run_frequency_mins INT NOT NULL,
  method text NOT NULL,
  url text NOT NULL,
  headers JSONB,
  payload JSONB,
  query_params JSONB,
  teardown text,
  status text NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP
);

CREATE TABLE notification_settings (
  id serial PRIMARY KEY,
  alerts_on_recovery BOOLEAN NOT NULL,
  alerts_on_failure BOOLEAN NOT NULL
); 

CREATE TABLE alerts (
  id serial PRIMARY KEY,
  type text NOT NULL,
  webhook text,
  notification_settings_id INT
    NOT NULL
    REFERENCES notification_settings (id)
    ON DELETE CASCADE
);

CREATE TABLE tests_alerts (
  id serial PRIMARY KEY,
  test_id INT
    NOT NULL
    REFERENCES tests (id)
    ON DELETE CASCADE,
  alerts_id INT
    NOT NULL
    REFERENCES alerts (id)
    ON DELETE CASCADE
);

CREATE TABLE regions (
  id serial PRIMARY KEY,
  display_name text NOT NULL,
  aws_name text NOT NULL,
  flag_url text NOT NULL
);

CREATE TABLE test_runs (
  id serial PRIMARY KEY,
  test_id INT
    NOT NULL
    REFERENCES tests (id)
    ON DELETE CASCADE,
  started_at TIMESTAMP NOT NULL,
  completed_at TIMESTAMP,
  pass BOOLEAN,
  region_id INT
    NOT NULL
    REFERENCES regions (id)
    ON DELETE CASCADE
); 

CREATE TABLE tests_regions (
  id serial PRIMARY KEY,
  test_id INT
    NOT NULL
    REFERENCES tests (id)
    ON DELETE CASCADE,
  region_id INT
    NOT NULL
    REFERENCES regions (id)
    ON DELETE CASCADE
); 

CREATE TABLE comparison_types (
  id serial PRIMARY KEY,
  name text NOT NULL,
  symbol text NOT NULL
); 

CREATE TABLE assertions (
  id serial PRIMARY KEY,
  test_id INT
    NOT NULL
    REFERENCES tests (id)
    ON DELETE CASCADE,
  type text NOT NULL,
  property text,
  comparison_type_id INT
    NOT NULL
    REFERENCES comparison_types (id)
    ON DELETE CASCADE,
  expected_value text
); 

CREATE TABLE assertion_results (
  id serial PRIMARY KEY,
  test_run_id INT
    NOT NULL
    REFERENCES test_runs (id)
    ON DELETE CASCADE,
  assertion_id INT
    NOT NULL
    REFERENCES assertions (id)
    ON DELETE CASCADE,
  actual_value text NOT NULL,
  pass BOOLEAN NOT NULL
); 



-- CREATE TABLE slack_alerts (
--   id serial PRIMARY KEY,
--   webhook text NOT NULL,
--   notification_settings_id INT
--     NOT NULL
--     REFERENCES notification_settings (id)
--     ON DELETE CASCADE
-- );


