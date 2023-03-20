package com.ai4ai.ycc.error.code;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

public interface ErrorCode {

    String name();
    String getCode();
    String getMessage();
    HttpStatus getHttpStatus();


}
