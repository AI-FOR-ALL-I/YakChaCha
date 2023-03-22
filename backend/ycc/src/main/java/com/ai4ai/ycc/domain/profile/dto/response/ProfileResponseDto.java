package com.ai4ai.ycc.domain.profile.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ProfileResponseDto {

    long profileLinkSeq;
    int imgCode;
    String nickname;
    String name;
    String gender;
    String birthDate;
    boolean isPregnancy;
    boolean isOwner;

}
