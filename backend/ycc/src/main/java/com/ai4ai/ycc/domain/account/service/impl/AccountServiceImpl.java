package com.ai4ai.ycc.domain.account.service.impl;

import com.ai4ai.ycc.config.security.JwtTokenProvider;
import com.ai4ai.ycc.domain.account.dto.request.SignInRequestDto;
import com.ai4ai.ycc.domain.account.dto.response.SignInResponseDto;
import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.account.repository.AccountRepository;
import com.ai4ai.ycc.domain.account.service.AccountService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class AccountServiceImpl implements AccountService {

    private final AccountRepository accountRepository;
    private final JwtTokenProvider jwtTokenProvider;

    @Override
    public SignInResponseDto signIn(SignInRequestDto requestDto) {
        log.info("[SignIn] 로그인 시작");

        String type = requestDto.getType();
        String id = requestDto.getId();
        String email = requestDto.getEmail();

        if (!accountRepository.existsById(id)) {
            log.info("[SignIn] 새로운 계정 등록 시작");
            Account newAccount = Account.builder()
                    .type(type)
                    .id(id)
                    .email(email)
                    .build();
            accountRepository.save(newAccount);
            log.info("[SignIn] 새로운 계정 등록 완료");
        }

        Account account = accountRepository.getById(id);

        log.info("[SignIn] 토큰 생성 시작");
        String accessToken = jwtTokenProvider.createAccessToken(id);
        String refreshToken = jwtTokenProvider.createRefreshToken(id);
        log.info("[SignIn] 토큰 생성 완료");

        account.putRefreshToken(refreshToken);
        accountRepository.save(account);

        return SignInResponseDto.builder()
                .isProfile(false)
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

    @Override
    public void signOut(Account account) {
        log.info("[SignOut] 로그아웃 시작");

        log.info("[SignOut] refresh token 제거 시작");
        account.removeRefreshToken();
        accountRepository.save(account);
        log.info("[SignOut] refresh token 제거 완료");

        log.info("[SignOut] 로그아웃 완료");
    }
}
