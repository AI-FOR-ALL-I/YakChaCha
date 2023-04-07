package com.ai4ai.ycc.domain.profile.dto.response;

import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
public class ConfirmLinkResponseDto {

    private long senderAccountSeq;
    private String senderAccountName;
    private List<ProfileLinkResponseDto> profiles;

}
