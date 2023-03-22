package com.ai4ai.ycc.domain.medicine.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ai4ai.ycc.domain.medicine.entity.Medicine;
import com.ai4ai.ycc.domain.medicine.entity.MedicineDetail;

public interface MedicineDetailRepository extends JpaRepository<MedicineDetail, Long> {
    MedicineDetail findByItemSeq(long item_seq);

}
