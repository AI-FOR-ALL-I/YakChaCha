package com.ai4ai.ycc.domain.profile.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class AccountResponseDto {

    private long profileLinkSeq;
    private String name;
    private String email;
    private String regDttm;

}
