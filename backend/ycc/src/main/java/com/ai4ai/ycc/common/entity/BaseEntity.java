package com.ai4ai.ycc.common.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.MappedSuperclass;
import java.time.LocalDateTime;

@Getter
@Setter
@MappedSuperclass
public class BaseEntity {

    private String delYn;
    private Long regAccountSeq;
    private LocalDateTime regDttm;
    private Long modAccountSeq;
    private LocalDateTime modDttm;

}
