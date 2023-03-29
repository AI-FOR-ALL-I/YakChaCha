package com.ai4ai.ycc.domain.medicine.repository;

import java.util.List;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import com.ai4ai.ycc.domain.medicine.entity.Medicine;

public interface MedicineRepository extends JpaRepository<Medicine, Long> {
    List<Medicine> findByItemNameLike(String input);
    List<Medicine> findByEdiCodeLike(String input);

    @EntityGraph(attributePaths = "detail")
    Medicine findByItemSeq(long itemSeq);

}
