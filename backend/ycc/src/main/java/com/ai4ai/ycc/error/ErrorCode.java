package com.ai4ai.ycc.error;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum ErrorCode {

    INVALID_PARAMETER("CM_001", "Invalid parameter included", HttpStatus.BAD_REQUEST),
    RESOURCE_NOT_FOUND("CM_002", "Resource not exists", HttpStatus.NOT_FOUND),
    INTERNAL_SERVER_ERROR("CM_003", "Internal server error", HttpStatus.INTERNAL_SERVER_ERROR),
    ACCOUNT_NOT_FOUND("AC_001", "존재하지 않는 계정입니다.", HttpStatus.NOT_FOUND),
    ID_DUPLICATION("AC_002", "이미 존재하는 아이디입니다.", HttpStatus.CONFLICT),
    PHONE_DUPLICATION("AC_003", "이미 존재하는 휴대폰 번호입니다.", HttpStatus.CONFLICT),
    ;

    private final String code;
    private final String message;
    private final HttpStatus status;


}
