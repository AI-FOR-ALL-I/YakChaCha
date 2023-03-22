package com.ai4ai.ycc.domain.profile.dto.request;

import lombok.Getter;

import java.time.LocalDate;

@Getter
public class CreateProfileRequestDto {

    private String name;
    private String gender;
    private boolean pregnancy;
    private String birthDate;
    private String nickname;
    private int imgCode;

}
