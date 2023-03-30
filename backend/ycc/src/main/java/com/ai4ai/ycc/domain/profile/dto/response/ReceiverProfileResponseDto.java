package com.ai4ai.ycc.domain.profile.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ReceiverProfileResponseDto {

    long profileSeq;
    int imgCode;
    String nickname;
    String name;
    String gender;
    String birthDate;
    boolean isPregnancy;

}
