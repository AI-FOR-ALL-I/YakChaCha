package com.ai4ai.ycc.domain.medicine.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ai4ai.ycc.domain.medicine.entity.MyMedicine;
import com.ai4ai.ycc.domain.medicine.entity.MyMedicineHasTag;
import com.ai4ai.ycc.domain.medicine.entity.Tag;

public interface MyMedicineHasTagRepository extends JpaRepository<MyMedicineHasTag, Long> {
    List<MyMedicineHasTag> findByMyMedicine(MyMedicine myMedicine);

	List<Tag> findByTag_ProfileSeq(long profileSeq);
}
