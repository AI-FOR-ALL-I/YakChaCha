package com.ai4ai.ycc.domain.account.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class SignInResponseDto {

    private boolean isProfile;
    private String accessToken;
    private String refreshToken;

}
