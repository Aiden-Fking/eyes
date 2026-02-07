INSERT INTO parents (id, phone, name)
VALUES ('00000000-0000-0000-0000-000000000001', '13800000000', '家长示例')
ON CONFLICT (phone) DO NOTHING;

INSERT INTO students (id, parent_id, name, age, grade, eye_condition_tags)
VALUES ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', '小明', 9, '三年级', 'stereo,visual_habit')
ON CONFLICT (id) DO NOTHING;

INSERT INTO training_plans (id, student_id, goal, minutes_per_day, start_date, status)
VALUES ('20000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', 'stereo', 15, CURRENT_DATE, 'active')
ON CONFLICT (id) DO NOTHING;

INSERT INTO training_sessions (session_id, student_id)
VALUES ('session-demo-001', '10000000-0000-0000-0000-000000000001')
ON CONFLICT (session_id) DO NOTHING;
