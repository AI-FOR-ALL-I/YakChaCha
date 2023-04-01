package com.ai4ai.ycc.domain.medicine.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ai4ai.ycc.domain.medicine.entity.Collision;

public interface CollisionRepository extends JpaRepository<Collision, Long> {
	boolean existsByMedicineAIdAndMedicineBId(int medicineAId, int medicineBId);
	List<Collision> findAllByMedicineAIdIn(List<Integer> myMedicineList);
}
