package com.ai4ai.ycc.error.code;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum TokenErrorCode implements ErrorCode {

    UNKNOWN_ERROR("TK_000", "알려지지않은 에러입니다.", HttpStatus.UNAUTHORIZED),
    TOKEN_NOT_FOUND("TK_001", "토큰이 존재하지 않습니다.",HttpStatus.UNAUTHORIZED),
    WRONG_TYPE_TOKEN("TK_002", "잘못된 토큰입니다.", HttpStatus.UNAUTHORIZED),
    EXPIRED_TOKEN("TK_003", "만료된 토큰입니다.", HttpStatus.UNAUTHORIZED),
    UNSUPPORTED_TOKEN("TK_004", "지원하지 않는 토큰입니다.", HttpStatus.UNAUTHORIZED),
    ACCESS_DENIED("TK_005", "접근이 거부되었습니다.", HttpStatus.UNAUTHORIZED),
    TOKEN_NOT_MATCH("TK_006", "리프레시 토큰이 일치하지 않습니다.", HttpStatus.BAD_REQUEST);

    private final String code;
    private final String message;
    private final HttpStatus httpStatus;

}
