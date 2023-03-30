package com.ai4ai.ycc.domain.medicine.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.ai4ai.ycc.domain.medicine.entity.MyMedicine;
import com.ai4ai.ycc.domain.medicine.entity.MyMedicineHasTag;
import com.ai4ai.ycc.domain.medicine.entity.Tag;

public interface MyMedicineHasTagRepository extends JpaRepository<MyMedicineHasTag, Long> {
    List<MyMedicineHasTag> findByMyMedicine(MyMedicine myMedicine);
	@Query("select m from MyMedicineHasTag m where m.tag.name in :tags and m.tag.profileSeq= :profileSeq")
	List<MyMedicineHasTag> findAllByTag_NameIn(List<String> tags, Long profileSeq);
}
