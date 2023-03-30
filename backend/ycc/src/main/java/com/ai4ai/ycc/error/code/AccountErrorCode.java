package com.ai4ai.ycc.error.code;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum AccountErrorCode implements ErrorCode {

    ACCOUNT_NOT_FOUND("AC_001", "존재하지 않는 계정입니다.",HttpStatus.NOT_FOUND),
    ID_DUPLICATION("AC_002", "이미 존재하는 아이디입니다.", HttpStatus.CONFLICT),
    PHONE_DUPLICATION("AC_003", "이미 존재하는 휴대폰 번호입니다.", HttpStatus.CONFLICT),
    YOUR_ACCOUNT("AC_004", "본인 계정입니다.", HttpStatus.BAD_REQUEST);

    private final String code;
    private final String message;
    private final HttpStatus httpStatus;

}
