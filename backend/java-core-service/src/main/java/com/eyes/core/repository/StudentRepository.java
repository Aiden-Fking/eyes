package com.eyes.core.repository;

import com.eyes.core.model.Student;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public class StudentRepository {
    private final JdbcTemplate jdbcTemplate;

    public StudentRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Student create(UUID parentId, String name, int age, String grade, String eyeConditionTags) {
        UUID id = UUID.randomUUID();
        jdbcTemplate.update("""
            INSERT INTO students(id, parent_id, name, age, grade, eye_condition_tags)
            VALUES(?, ?, ?, ?, ?, ?)
            """, id, parentId, name, age, grade, eyeConditionTags);
        return new Student(id, parentId, name, age, grade, eyeConditionTags);
    }

    public List<Student> listByParent(UUID parentId) {
        return jdbcTemplate.query("""
            SELECT id, parent_id, name, age, grade, eye_condition_tags
            FROM students WHERE parent_id = ? ORDER BY created_at DESC
            """, (rs, i) -> new Student(
                UUID.fromString(rs.getString("id")),
                UUID.fromString(rs.getString("parent_id")),
                rs.getString("name"),
                rs.getInt("age"),
                rs.getString("grade"),
                rs.getString("eye_condition_tags")
        ), parentId);
    }
}
