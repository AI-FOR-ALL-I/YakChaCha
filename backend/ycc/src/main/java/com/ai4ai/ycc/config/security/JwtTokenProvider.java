/*
 * JwtTokenProvider
 *
 * Version 1.0.0
 *
 * Date 21.10.24
 */


package com.ai4ai.ycc.config.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.SignatureException;
import io.jsonwebtoken.UnsupportedJwtException;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Date;
import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

@Component
@RequiredArgsConstructor
@Slf4j
public class JwtTokenProvider {

    @Value("${jwt.header}")
    private String AUTHORIZATION_HEADER = "header";

    private final long ACCESS_TOKEN_EXPIRE_TIME = 1000L * 60 * 60; // 1시간 토큰 유효
    private final long REFRESH_TOKEN_EXPIRE_TIME = 1000L * 60 * 60 * 24 * 7; // 1주 토큰 유효
    private final UserDetailsService userDetailsService; // Spring Security 에서 제공하는 서비스 레이어

    @Value("${jwt.secret}")
    private String secretKey = "secretKey";


    // SecretKey 에 대해 인코딩 수행
    @PostConstruct
    protected void init() {
        secretKey = Base64.getEncoder().encodeToString(secretKey.getBytes(StandardCharsets.UTF_8));
    }

    // JWT 토큰 생성
    public String createAccessToken(String userUid) {
        log.info("[createToken] 토큰 생성 시작");
        Claims claims = Jwts.claims().setSubject(userUid);

        long now = (new Date()).getTime();
        Date issuedAt = new Date(now);
        Date expiration = new Date(now + ACCESS_TOKEN_EXPIRE_TIME);

        //Date now = new Date();
        return Jwts.builder()
                .setClaims(claims) // 저장 정보
                .setIssuedAt(issuedAt) // 토큰 발행 시간 정보
                .setExpiration(expiration) // 만료 시간
                .signWith(SignatureAlgorithm.HS256, secretKey) // 암호화 알고리즘, secret 값 세팅
                .compact();
    }

    public String createRefreshToken(String userUid) {
        log.info("[createRefreshToken] 토큰 생성 시작");
        Claims claims = Jwts.claims().setSubject(userUid);

        long now = (new Date()).getTime();
        Date issuedAt = new Date(now);
        Date expiration = new Date(now + REFRESH_TOKEN_EXPIRE_TIME);

        //Date now = new Date();
        return Jwts.builder()
                .setClaims(claims) // 저장 정보
                .setIssuedAt(issuedAt) // 토큰 발행 시간 정보
                .setExpiration(expiration) // 만료 시간
                .signWith(SignatureAlgorithm.HS256, secretKey) // 암호화 알고리즘, secret 값 세팅
                .compact();
    }

    // JWT 토큰으로 인증 정보 조회
    public Authentication getAuthentication(String token) {
        log.info("[getAuthentication] 토큰 인증 정보 조회 시작");
        UserDetails userDetails = userDetailsService.loadUserByUsername(this.getUsername(token));
        log.info("[getAuthentication] 토큰 인증 정보 조회 완료, UserDetails UserName : {}",
            userDetails.getUsername());
        return new UsernamePasswordAuthenticationToken(userDetails, "",
            userDetails.getAuthorities());
    }

    // JWT 토큰에서 회원 구별 정보 추출
    public String getUsername(String token) {
        log.info("[getUsername] 토큰 기반 회원 구별 정보 추출");
        log.info("[getUsername] Secret Key: {}", secretKey);
        String info = Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token).getBody()
            .getSubject();
        log.info("[getUsername] 토큰 기반 회원 구별 정보 추출 완료, info : {}", info);
        return info;
    }

    public String resolveToken(HttpServletRequest request) {
        log.info("[resolveToken] HTTP 헤더에서 Token 값 추출");
        String token = request.getHeader(AUTHORIZATION_HEADER);
        if(StringUtils.hasText(token) && token.startsWith("Bearer ")){
            return token.substring(7);
        }
        return null;
    }

    // JWT 토큰의 유효성 + 만료일 체크
    public boolean validateToken(String token) {
        try {
            log.info("[validateToken] 토큰 유효 체크 시작");
            Jws<Claims> claims = Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token);
            log.info("[validateToken] 토큰 유효 체크 완료");
            return !claims.getBody().getExpiration().before(new Date());
        } catch (SignatureException | MalformedJwtException e) {
            log.info("[validateToken] 잘못된 서명입니다.");
        } catch (ExpiredJwtException e) {
            log.info("[validateToken] 만료된 토큰입니다.");
        } catch (UnsupportedJwtException e) {
            log.info("[validateToken] 지원하지 않는 토큰입니다.");
        } catch (IllegalStateException e) {
            log.info("[validateToken] 토큰이 잘못되었습니다.");
        }
        return false;
    }
}
