package com.ai4ai.ycc.config.security;

import com.ai4ai.ycc.error.code.AccountErrorCode;
import com.ai4ai.ycc.error.code.TokenErrorCode;
import com.ai4ai.ycc.error.exception.AccountNotFoundException;
import com.ai4ai.ycc.error.exception.TokenNotFoundException;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.SignatureException;
import io.jsonwebtoken.UnsupportedJwtException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@RequiredArgsConstructor
@Slf4j
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwtTokenProvider;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {
        try {
            String token = jwtTokenProvider.resolveToken(request);
            String requestURI = request.getRequestURI();
            if (StringUtils.hasText(token) && jwtTokenProvider.validateToken(token)) {
                Authentication authentication = jwtTokenProvider.getAuthentication(token);
                SecurityContextHolder.getContext().setAuthentication(authentication);
                log.info("[doFilterInternal] Security Context에 '{}' 인증 정보를 저장했습니다, uri: {}", authentication.getName(), requestURI);
            } else {
                log.info("[doFilterInternal] 유효한 JWT 토큰이 없습니다., uri: {}", requestURI);
            }
        } catch (AccountNotFoundException e) {
            request.setAttribute("exception", AccountErrorCode.ACCOUNT_NOT_FOUND.name());
        } catch (TokenNotFoundException e) {
            request.setAttribute("exception", TokenErrorCode.TOKEN_NOT_FOUND.name());
        } catch (SignatureException | MalformedJwtException e) {
            request.setAttribute("exception", TokenErrorCode.WRONG_TYPE_TOKEN.name());
        } catch (ExpiredJwtException e) {
            request.setAttribute("exception", TokenErrorCode.EXPIRED_TOKEN.name());
        } catch (UnsupportedJwtException e) {
            request.setAttribute("exception", TokenErrorCode.UNSUPPORTED_TOKEN.name());
        } catch (Exception e) {
            request.setAttribute("exception", TokenErrorCode.UNKNOWN_ERROR.name());
        }

        log.info("[doFilterInternal] doFilter");
        filterChain.doFilter(request, response);
    }

}