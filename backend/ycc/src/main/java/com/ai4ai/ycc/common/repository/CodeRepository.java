package com.ai4ai.ycc.common.repository;

import com.ai4ai.ycc.common.entity.Code;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CodeRepository extends JpaRepository<Code, Long> {

    Code findByCode(String code);
    Code findByName(String name);

}
