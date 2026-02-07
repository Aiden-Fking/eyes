package com.eyes.core.controller;

import com.eyes.core.model.Plan;
import com.eyes.core.model.Student;
import com.eyes.core.repository.PlanRepository;
import com.eyes.core.repository.StudentRepository;
import com.eyes.core.service.WeeklyReportService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/v1")
public class CoreController {
    private final StudentRepository studentRepository;
    private final PlanRepository planRepository;
    private final WeeklyReportService weeklyReportService;

    public CoreController(StudentRepository studentRepository, PlanRepository planRepository, WeeklyReportService weeklyReportService) {
        this.studentRepository = studentRepository;
        this.planRepository = planRepository;
        this.weeklyReportService = weeklyReportService;
    }

    @GetMapping("/healthz")
    public Map<String, String> healthz() {
        return Map.of("status", "ok");
    }

    @PostMapping("/students")
    public Student createStudent(@RequestBody Map<String, String> req) {
        return studentRepository.create(
            UUID.fromString(req.get("parentId")),
            req.get("name"),
            Integer.parseInt(req.get("age")),
            req.get("grade"),
            req.getOrDefault("eyeConditionTags", "")
        );
    }

    @GetMapping("/students")
    public List<Student> listStudents(@RequestParam("parentId") UUID parentId) {
        return studentRepository.listByParent(parentId);
    }

    @PostMapping("/training/plans")
    public Plan createPlan(@RequestBody Map<String, String> req) {
        return planRepository.create(
            UUID.fromString(req.get("studentId")),
            req.get("goal"),
            Integer.parseInt(req.get("minutesPerDay"))
        );
    }

    @GetMapping("/training/plans")
    public List<Plan> listPlans(@RequestParam("studentId") UUID studentId) {
        return planRepository.listByStudent(studentId);
    }

    @GetMapping("/reports/weekly")
    public Map<String, Object> weekly(@RequestParam("studentId") UUID studentId) {
        return weeklyReportService.build(studentId);
    }
}
