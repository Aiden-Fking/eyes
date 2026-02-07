package com.eyes.core.repository;

import com.eyes.core.model.Plan;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Repository
public class PlanRepository {
    private final JdbcTemplate jdbcTemplate;

    public PlanRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Plan create(UUID studentId, String goal, int minutesPerDay) {
        UUID id = UUID.randomUUID();
        LocalDate startDate = LocalDate.now();
        jdbcTemplate.update("""
            INSERT INTO training_plans(id, student_id, goal, minutes_per_day, start_date, status)
            VALUES(?, ?, ?, ?, ?, 'active')
            """, id, studentId, goal, minutesPerDay, startDate);
        return new Plan(id, studentId, goal, minutesPerDay, startDate, "active");
    }

    public List<Plan> listByStudent(UUID studentId) {
        return jdbcTemplate.query("""
            SELECT id, student_id, goal, minutes_per_day, start_date, status
            FROM training_plans WHERE student_id = ? ORDER BY created_at DESC
            """, (rs, i) -> new Plan(
                UUID.fromString(rs.getString("id")),
                UUID.fromString(rs.getString("student_id")),
                rs.getString("goal"),
                rs.getInt("minutes_per_day"),
                rs.getDate("start_date").toLocalDate(),
                rs.getString("status")
        ), studentId);
    }
}
