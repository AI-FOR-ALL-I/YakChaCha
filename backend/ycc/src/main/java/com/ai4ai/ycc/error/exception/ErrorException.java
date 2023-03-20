package com.ai4ai.ycc.error.exception;

import com.ai4ai.ycc.error.code.ErrorCode;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public class ErrorException extends RuntimeException {

    private final ErrorCode errorCode;

}
