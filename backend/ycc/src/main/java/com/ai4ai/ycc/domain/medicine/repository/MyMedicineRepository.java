package com.ai4ai.ycc.domain.medicine.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

import com.ai4ai.ycc.domain.medicine.entity.MyMedicine;
import com.ai4ai.ycc.domain.profile.entity.Profile;

public interface MyMedicineRepository extends JpaRepository<MyMedicine, Long> {
    List<MyMedicine> findAllByDelYnAndFinishAndProfile(String deleted, String finished, Profile profile);
    MyMedicine findByMyMedicineSeq(long myMedicineSeq);
}
