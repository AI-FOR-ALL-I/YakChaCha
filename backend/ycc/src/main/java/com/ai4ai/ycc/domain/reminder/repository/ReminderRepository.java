package com.ai4ai.ycc.domain.reminder.repository;

import com.ai4ai.ycc.domain.reminder.entity.Reminder;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReminderRepository extends JpaRepository<Reminder, Long> {
}
