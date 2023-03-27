package com.ai4ai.ycc.domain.reminder.repository;

import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.reminder.entity.Reminder;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ReminderRepository extends JpaRepository<Reminder, Long> {
    List<Reminder> findAllByProfileAndDelYn(Profile profile, String delYn);

    Optional<Reminder> findByReminderSeqAndProfileAndDelYn(long reminderSeq, Profile profile, String delYn);

    List<Reminder> findAllByDelYn(String delYn);
}
