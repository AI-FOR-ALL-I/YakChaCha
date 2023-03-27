package com.ai4ai.ycc.error.code;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum ReminderErrorCode implements ErrorCode {

    REMINDER_ERROR_CODE("RM_000", "리마인더 에러가 발생했습니다.", HttpStatus.BAD_REQUEST),
    ALREADY_TAKEN("RM_001", "이미 약을 먹었습니다.", HttpStatus.BAD_REQUEST);

    private final String code;
    private final String message;
    private final HttpStatus httpStatus;

}
