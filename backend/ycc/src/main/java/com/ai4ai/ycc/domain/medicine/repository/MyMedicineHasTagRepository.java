package com.ai4ai.ycc.domain.medicine.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.ai4ai.ycc.domain.medicine.entity.MyMedicine;
import com.ai4ai.ycc.domain.medicine.entity.MyMedicineHasTag;
import com.ai4ai.ycc.domain.medicine.entity.Tag;

public interface MyMedicineHasTagRepository extends JpaRepository<MyMedicineHasTag, Long> {
	MyMedicineHasTag findByTag_NameAndDelYnAndTag_ProfileSeq(String tagName, String delYn, long profileSeq);
	List<MyMedicineHasTag> findByMyMedicineAndDelYn(MyMedicine myMedicine, String Yn);
	@Query("select m from MyMedicineHasTag m where m.tag.name in :tags and m.tag.profileSeq= :profileSeq and m.delYn= 'N' ")
	List<MyMedicineHasTag> findAllByDelYnAndTag_NameIn(List<String> tags, Long profileSeq);

	List<MyMedicineHasTag> findAllByDelYnAndMyMedicine(String delYn, MyMedicine myMedicine);
}
