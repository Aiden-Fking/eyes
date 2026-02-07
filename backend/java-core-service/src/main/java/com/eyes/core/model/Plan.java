package com.eyes.core.model;

import java.time.LocalDate;
import java.util.UUID;

public record Plan(UUID id, UUID studentId, String goal, Integer minutesPerDay, LocalDate startDate, String status) {
}
