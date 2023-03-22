package com.ai4ai.ycc.common.entity;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.Column;
import javax.persistence.EntityListeners;
import javax.persistence.MappedSuperclass;
import javax.persistence.PrePersist;
import java.time.LocalDateTime;

@Getter
@Setter
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public class BaseEntity {

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

    @PrePersist
    public void setDefaultValues() {
        this.delYn = this.delYn == null ? "N" : this.delYn;
    }

    public void remove() {
        this.delYn = "Y";
    }

}
