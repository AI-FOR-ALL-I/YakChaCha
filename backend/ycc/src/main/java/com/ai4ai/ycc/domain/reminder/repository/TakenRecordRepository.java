package com.ai4ai.ycc.domain.reminder.repository;

import com.ai4ai.ycc.domain.reminder.entity.TakenRecord;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TakenRecordRepository extends JpaRepository<TakenRecord, Long> {

}
