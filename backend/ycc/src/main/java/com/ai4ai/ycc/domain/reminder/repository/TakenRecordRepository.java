package com.ai4ai.ycc.domain.reminder.repository;

import com.ai4ai.ycc.domain.reminder.entity.Reminder;
import com.ai4ai.ycc.domain.reminder.entity.TakenRecord;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface TakenRecordRepository extends JpaRepository<TakenRecord, Long> {

    List<TakenRecord> findAllByReminderAndDelYnAndDateBetween(Reminder reminder, String delYn, LocalDate startDate, LocalDate endDate);

    List<TakenRecord> findAllByReminderAndDelYn(Reminder reminder, String delYn);
}
