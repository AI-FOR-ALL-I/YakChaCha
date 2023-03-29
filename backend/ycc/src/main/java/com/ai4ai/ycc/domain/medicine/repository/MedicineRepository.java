package com.ai4ai.ycc.domain.medicine.repository;

import java.util.List;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import com.ai4ai.ycc.domain.medicine.entity.Medicine;

public interface MedicineRepository extends JpaRepository<Medicine, Long> {
    List<Medicine> findAllByItemNameLike(String input);
    List<Medicine> findAllByEdiCodeLike(String input);

    @EntityGraph(attributePaths = "detail")
    Medicine findByItemSeq(long itemSeq);

}
