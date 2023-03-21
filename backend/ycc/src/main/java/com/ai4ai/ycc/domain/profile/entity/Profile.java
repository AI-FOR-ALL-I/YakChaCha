package com.ai4ai.ycc.domain.profile.entity;

import com.ai4ai.ycc.common.entity.BaseEntity;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.*;
import org.hibernate.annotations.DynamicInsert;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@ToString
@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
public class Profile extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long profileSeq;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, length = 1)
    private String gender;

    @Column(nullable = false, columnDefinition = "TINYINT", length = 1)
    private boolean pregnancy;

    @Column(nullable = false)
    private LocalDate birthDate;

    @Builder
    public Profile(String name, String gender, boolean pregnancy, LocalDate birthDate) {
        this.name = name;
        this.gender = gender;
        this.pregnancy = pregnancy;
        this.birthDate = birthDate;
    }

    @Override
    public void setDefaultValues() {
        super.setDefaultValues();
    }

}
