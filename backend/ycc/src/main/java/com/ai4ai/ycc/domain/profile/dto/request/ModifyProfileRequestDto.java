package com.ai4ai.ycc.domain.profile.dto.request;

import lombok.Getter;

@Getter
public class ModifyProfileRequestDto {

    private int imgCode;
    private String nickname;
    private String name;
    private String gender;
    private boolean pregnancy;
    private String birthDate;

}
