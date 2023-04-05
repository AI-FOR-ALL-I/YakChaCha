package com.ai4ai.ycc.domain.profile.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ProfileResponseDto {

    private long profileLinkSeq;
    private int imgCode;
    private String nickname;
    private String name;
    private String gender;
    private String birthDate;
    private boolean isPregnancy;
    private boolean isOwner;

}
