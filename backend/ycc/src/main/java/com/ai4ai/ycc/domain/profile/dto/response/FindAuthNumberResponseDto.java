package com.ai4ai.ycc.domain.profile.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class FindAuthNumberResponseDto {

    String senderName;
    String authNumber;

}
