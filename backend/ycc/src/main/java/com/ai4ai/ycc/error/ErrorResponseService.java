package com.ai4ai.ycc.error;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class ErrorResponseService {

    private ErrorResponse makeErrorResponse(final ErrorCode errorCode) {
        return ErrorResponse.builder()
                .success(false)
                .code(errorCode.getCode())
                .error(errorCode.name())
                .message(errorCode.getMessage())
                .build();
    }

    public ResponseEntity<Object> handleExceptionInternal(final ErrorCode errorCode) {
        log.warn("{}: {} {} {}", errorCode.getStatus(), errorCode.getCode(), errorCode.name(), errorCode.getMessage());
        return ResponseEntity.status(errorCode.getStatus())
                .body(makeErrorResponse(errorCode));
    }

}
