package com.ai4ai.ycc.error.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ErrorResponse {

    private final boolean success;
    private final String code;
    private final String error;
    private final String message;

}

