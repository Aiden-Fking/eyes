package com.eyes.core.model;

import java.util.UUID;

public record Student(UUID id, UUID parentId, String name, Integer age, String grade, String eyeConditionTags) {
}
