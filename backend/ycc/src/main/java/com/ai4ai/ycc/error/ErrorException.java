package com.ai4ai.ycc.error;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public class ErrorException extends RuntimeException {

    private final ErrorCode errorCode;

}
