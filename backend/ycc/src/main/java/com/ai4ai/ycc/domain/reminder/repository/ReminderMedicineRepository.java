package com.ai4ai.ycc.domain.reminder.repository;

import com.ai4ai.ycc.domain.reminder.entity.Reminder;
import com.ai4ai.ycc.domain.reminder.entity.ReminderMedicine;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ReminderMedicineRepository extends JpaRepository<ReminderMedicine, Long> {
    List<ReminderMedicine> findAllByReminderAndDelYn(Reminder reminder, String delYn);

    List<ReminderMedicine> findAllByReminderAndMedicineSeqAndDelYn(Reminder reminder, long itemSeq, String delYn);

    Optional<ReminderMedicine> findByReminderAndMedicineSeqAndDelYn(Reminder reminder, long itemSeq, String delYn);
}
