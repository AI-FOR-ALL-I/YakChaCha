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
                .error(errorCode.getStatus().name())
                .message(errorCode.getMessage())
                .build();
    }

    public ResponseEntity<Object> handleExceptionInternal(final ErrorCode errorCode) {
        log.warn("{}: {} 에러 발생", errorCode.getStatus(), errorCode.name());
        return ResponseEntity.status(errorCode.getStatus())
                .body(makeErrorResponse(errorCode));
    }

}
