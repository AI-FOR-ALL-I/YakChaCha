package com.ai4ai.ycc.domain.profile.entity;

import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@ToString
@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
public class Profile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long profileSeq;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String genderCode;

    @Column(nullable = false, columnDefinition = "TINYINT", length = 1)
    private boolean pregnancy;

    @Column(nullable = false)
    private LocalDate birthDate;




}
