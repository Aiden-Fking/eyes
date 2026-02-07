package com.eyes.core.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.UUID;

@Service
public class WeeklyReportService {
    private final JdbcTemplate jdbcTemplate;

    public WeeklyReportService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Map<String, Object> build(UUID studentId) {
        Integer daysCompleted = jdbcTemplate.queryForObject("""
            SELECT COUNT(DISTINCT DATE(event_time))
            FROM training_events te
            JOIN training_sessions ts ON ts.session_id = te.session_id
            WHERE ts.student_id = ?
              AND event_time >= NOW() - INTERVAL '7 days'
            """, Integer.class, studentId);

        Integer events = jdbcTemplate.queryForObject("""
            SELECT COUNT(*)
            FROM training_events te
            JOIN training_sessions ts ON ts.session_id = te.session_id
            WHERE ts.student_id = ?
              AND event_time >= NOW() - INTERVAL '7 days'
            """, Integer.class, studentId);

        return Map.of(
            "studentId", studentId,
            "daysCompleted", daysCompleted == null ? 0 : daysCompleted,
            "events", events == null ? 0 : events,
            "advice", "建议每天固定时段训练15分钟，保持连续性。"
        );
    }
}
