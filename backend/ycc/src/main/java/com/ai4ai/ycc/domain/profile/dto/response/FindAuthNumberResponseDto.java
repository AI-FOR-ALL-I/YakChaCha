package com.ai4ai.ycc.domain.profile.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class FindAuthNumberResponseDto {

    private String senderName;
    private String authNumber;

}
