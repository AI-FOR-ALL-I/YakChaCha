package com.ai4ai.ycc.domain.medicine.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ai4ai.ycc.domain.medicine.entity.Tag;

public interface TagRepository extends JpaRepository<Tag, Long> {
    List<Tag> findByProfileSeq(long profileSeq);
}
