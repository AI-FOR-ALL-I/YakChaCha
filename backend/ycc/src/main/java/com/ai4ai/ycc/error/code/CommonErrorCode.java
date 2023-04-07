package com.ai4ai.ycc.error.code;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum CommonErrorCode implements ErrorCode {

    BAD_REQUEST("CM_000", "잘못된 요청입니다.", HttpStatus.BAD_REQUEST),
    INVALID_PARAMETER("CM_001", "Invalid parameter included",HttpStatus.BAD_REQUEST),
    RESOURCE_NOT_FOUND("CM_002", "Resource not exists", HttpStatus.NOT_FOUND),
    INTERNAL_SERVER_ERROR("CM_003", "Internal server error", HttpStatus.INTERNAL_SERVER_ERROR);

    private final String code;
    private final String message;
    private final HttpStatus httpStatus;

}
