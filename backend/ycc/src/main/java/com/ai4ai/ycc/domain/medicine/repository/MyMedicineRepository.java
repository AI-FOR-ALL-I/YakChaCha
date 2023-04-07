package com.ai4ai.ycc.domain.medicine.repository;

import java.util.List;
import java.util.Optional;

import com.ai4ai.ycc.domain.medicine.entity.Medicine;
import org.springframework.data.jpa.repository.JpaRepository;

import com.ai4ai.ycc.domain.medicine.entity.MyMedicine;
import com.ai4ai.ycc.domain.profile.entity.Profile;

public interface MyMedicineRepository extends JpaRepository<MyMedicine, Long> {
    List<MyMedicine> findAllByDelYnAndFinishAndProfile(String deleted, String finished, Profile profile);
    List<MyMedicine> findAllByDelYnAndProfile(String deleted, Profile profile);
    MyMedicine findByMyMedicineSeq(long myMedicineSeq);

	List<MyMedicine> findAllByDelYnAndFinish(String deleted, String finish);

    Optional<MyMedicine> findByMedicineAndDelYn(Medicine medicine, String delYn);

    Optional<MyMedicine> findByProfileAndMedicineAndDelYn(Profile profile, Medicine medicine, String delYn);

    Optional<MyMedicine> findByProfileAndMedicineAndFinishAndDelYn(Profile profile, Medicine medicine, String finish, String delYn);
}
