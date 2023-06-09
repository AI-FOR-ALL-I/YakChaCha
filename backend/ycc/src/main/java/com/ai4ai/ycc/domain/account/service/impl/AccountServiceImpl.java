package com.ai4ai.ycc.domain.account.service.impl;

import com.ai4ai.ycc.config.security.JwtTokenProvider;
import com.ai4ai.ycc.domain.account.dto.request.SignInRequestDto;
import com.ai4ai.ycc.domain.account.dto.response.RefreshResponseDto;
import com.ai4ai.ycc.domain.account.dto.response.SignInResponseDto;
import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.account.repository.AccountRepository;
import com.ai4ai.ycc.domain.account.service.AccountService;
import com.ai4ai.ycc.domain.profile.repository.ProfileLinkRepository;

import javax.servlet.http.HttpServletRequest;
import javax.transaction.Transactional;

import com.ai4ai.ycc.error.code.TokenErrorCode;
import com.ai4ai.ycc.error.exception.ErrorException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class AccountServiceImpl implements AccountService {

    private final AccountRepository accountRepository;
    private final ProfileLinkRepository profileLinkRepository;
    private final JwtTokenProvider jwtTokenProvider;

    @Override
    public SignInResponseDto signIn(SignInRequestDto requestDto) {
        log.info("[SignIn] 로그인 시작");

        String type = requestDto.getType();
        String id = requestDto.getId();
        String name = requestDto.getName();
        String email = requestDto.getEmail();
        String deviceToken = requestDto.getDeviceToken();

        if (!accountRepository.existsByIdAndDelYn(id, "N")) {
            log.info("[SignIn] 새로운 계정 등록 시작");
            Account newAccount = Account.builder()
                    .type(type)
                    .id(id)
                    .name(name)
                    .email(email)
                    .deviceToken(deviceToken)
                    .build();
            accountRepository.save(newAccount);
            log.info("[SignIn] 새로운 계정 등록 완료");
        }

        Account account = accountRepository.getByIdAndDelYn(id, "N");

        boolean isProfile = profileLinkRepository.existsByAccountAndDelYn(account, "N");

        log.info("[SignIn] 토큰 생성 시작");
        String accessToken = jwtTokenProvider.createAccessToken(id);
        String refreshToken = jwtTokenProvider.createRefreshToken(id);
        log.info("[SignIn] 토큰 생성 완료");

        account.login(refreshToken, deviceToken);
        accountRepository.save(account);

        return SignInResponseDto.builder()
                .isProfile(isProfile)
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

    @Override
    public void signOut(Account account) {
        log.info("[SignOut] 로그아웃 시작");

        log.info("[SignOut] refresh token, device token 제거 시작");
        account.logout();
        accountRepository.save(account);
        log.info("[SignOut] refresh token, device token 제거 완료");

        log.info("[SignOut] 로그아웃 완료");
    }

    @Override
    public void withdraw(Account account) {
        log.info("[Withdrawl] 회원탈퇴 시작");
        account.withdraw();
        accountRepository.save(account);
        log.info("[Withdrawl] 회원탈퇴 완료");
    }

    @Override
    public RefreshResponseDto refresh(Account account, HttpServletRequest request) {
        String token = jwtTokenProvider.resolveToken(request);

        if (!token.equals(account.getRefreshToken())) {
            throw new ErrorException(TokenErrorCode.TOKEN_NOT_MATCH);
        }

        String id = account.getId();

        log.info("[SignIn] 토큰 생성 시작");
        String accessToken = jwtTokenProvider.createAccessToken(id);
        String refreshToken = jwtTokenProvider.createRefreshToken(id);
        log.info("[SignIn] 토큰 생성 완료");

        account.refresh(refreshToken);
        accountRepository.save(account);

        return RefreshResponseDto.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }
}
