package com.ai4ai.ycc.common.entity;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.Column;
import javax.persistence.EntityListeners;
import javax.persistence.MappedSuperclass;
import java.time.LocalDateTime;

@Getter
@Setter
@MappedSuperclass
@DynamicInsert
@EntityListeners(AuditingEntityListener.class)
public class BaseEntity {

    @Column(nullable = false, length = 1)
    @ColumnDefault("'N'")
    private String delYn;

    @CreatedBy
    private Long regAccountSeq;

    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime regDttm;

    @LastModifiedBy
    private Long modAccountSeq;
    @LastModifiedDate
    private LocalDateTime modDttm;

}
