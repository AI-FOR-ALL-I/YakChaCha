package com.ai4ai.ycc.error.code;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum ProfileLinkErrorCode implements ErrorCode {

    BAD_REQUEST("PL_000", "잘못된 요청입니다.", HttpStatus.BAD_REQUEST),
    NOT_FOUND_PROFILE_LINK("PL_001", "일치하는 프로필 연동을 찾을 수 없습니다.",HttpStatus.NOT_FOUND),
    NOT_FOUND_LINK("PL_002", "연동 요청 정보가 존재하지 않습니다.", HttpStatus.NOT_FOUND);

    private final String code;
    private final String message;
    private final HttpStatus httpStatus;

}
