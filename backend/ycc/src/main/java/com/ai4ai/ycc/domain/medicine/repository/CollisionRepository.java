package com.ai4ai.ycc.domain.medicine.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ai4ai.ycc.domain.medicine.entity.Collision;

public interface CollisionRepository extends JpaRepository<Collision, Long> {
	List<Collision> findAllByMedicineAIdInOrMedicineBIdIn(List<Integer> myMedicineList1,List<Integer> myMedicineList2);
	List<Collision> findAllByMedicineAIdOrMedicineBId(int medicineAId, int medicineBId);
}
