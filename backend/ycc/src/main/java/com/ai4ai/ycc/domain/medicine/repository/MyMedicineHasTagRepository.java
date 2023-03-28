package com.ai4ai.ycc.domain.medicine.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ai4ai.ycc.domain.medicine.entity.MyMedicine;
import com.ai4ai.ycc.domain.medicine.entity.MyMedicineHasTag;

public interface MyMedicineHasTagRepository extends JpaRepository<MyMedicineHasTag, Long> {
    List<MyMedicineHasTag> findByMyMedicine(MyMedicine myMedicine);
}
