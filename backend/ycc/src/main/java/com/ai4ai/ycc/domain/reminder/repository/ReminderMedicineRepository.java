package com.ai4ai.ycc.domain.reminder.repository;

import com.ai4ai.ycc.domain.reminder.entity.Reminder;
import com.ai4ai.ycc.domain.reminder.entity.ReminderMedicine;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ReminderMedicineRepository extends JpaRepository<ReminderMedicine, Long> {
    List<ReminderMedicine> findAllByReminderAndDelYn(Reminder reminder, String delYn);
}
