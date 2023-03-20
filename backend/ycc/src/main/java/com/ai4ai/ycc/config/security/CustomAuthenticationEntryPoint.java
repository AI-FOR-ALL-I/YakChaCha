package com.ai4ai.ycc.config.security;

import com.ai4ai.ycc.error.ErrorCode;
import com.ai4ai.ycc.error.ErrorResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

// 인증 실패시 결과를 처리해주는 로직을 가지고 있는 클래스
@Component
@RequiredArgsConstructor
@Slf4j
public class CustomAuthenticationEntryPoint implements AuthenticationEntryPoint {

    private final ObjectMapper objectMapper;

    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException) throws IOException, ServletException {
        log.info("[commence] 인증 실패로 response.sendError 발생");

        String exception = String.valueOf(request.getAttribute("exception"));

        //if (exception == null) {
        //    setResponse(response, TokenErrorCode.UNKNOWN_ERROR);
        //}
        //else if (exception.equals(UserErrorCode.USER_NOT_FOUND.name())) {
        //    setResponse(response, UserErrorCode.USER_NOT_FOUND);
        //}
        //else if (exception.equals(TokenErrorCode.TOKEN_NOT_FOUND.name())) {
        //    setResponse(response, TokenErrorCode.TOKEN_NOT_FOUND);
        //}
        //else if (exception.equals(TokenErrorCode.WRONG_TYPE_TOKEN.name())) {
        //    setResponse(response, TokenErrorCode.WRONG_TYPE_TOKEN);
        //}
        //else if (exception.equals(TokenErrorCode.EXPIRED_TOKEN.name())) {
        //    setResponse(response, TokenErrorCode.EXPIRED_TOKEN);
        //}
        //else if (exception.equals(TokenErrorCode.UNSUPPORTED_TOKEN.name())) {
        //    setResponse(response, TokenErrorCode.UNSUPPORTED_TOKEN);
        //}
        //else {
        //    setResponse(response, TokenErrorCode.ACCESS_DENIED);
        //}
    }

    //한글 출력을 위해 getWriter() 사용
    private void setResponse(HttpServletResponse response, ErrorCode errorCode)
            throws IOException {
        log.warn("[ErrorResponse] {}: {} 에러 발생", errorCode.getStatus(), errorCode.name());
        response.setContentType("application/json;charset=UTF-8");
        response.setStatus(errorCode.getStatus().value());

        response.getWriter().write(objectMapper.writeValueAsString(
                ErrorResponse.builder()
                        .success(false)
                        .error(errorCode.name())
                        .message(errorCode.getMessage())
                        .build()
        ));
    }
}