CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS parents (
    id UUID PRIMARY KEY,
    phone VARCHAR(32) UNIQUE NOT NULL,
    name VARCHAR(64) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS students (
    id UUID PRIMARY KEY,
    parent_id UUID NOT NULL REFERENCES parents(id),
    name VARCHAR(64) NOT NULL,
    age INT NOT NULL CHECK (age BETWEEN 5 AND 18),
    grade VARCHAR(32) NOT NULL,
    eye_condition_tags TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS training_plans (
    id UUID PRIMARY KEY,
    student_id UUID NOT NULL REFERENCES students(id),
    goal VARCHAR(64) NOT NULL,
    minutes_per_day INT NOT NULL CHECK (minutes_per_day BETWEEN 5 AND 30),
    start_date DATE NOT NULL,
    status VARCHAR(16) NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS training_sessions (
    session_id VARCHAR(64) PRIMARY KEY,
    student_id UUID NOT NULL REFERENCES students(id),
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ended_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS training_events (
    id BIGSERIAL PRIMARY KEY,
    session_id VARCHAR(64) NOT NULL REFERENCES training_sessions(session_id),
    event_type VARCHAR(64) NOT NULL,
    payload JSONB NOT NULL,
    event_time TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_events_session ON training_events(session_id);
CREATE INDEX IF NOT EXISTS idx_events_time ON training_events(event_time);
