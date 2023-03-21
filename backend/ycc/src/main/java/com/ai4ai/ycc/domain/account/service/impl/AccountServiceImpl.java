package com.ai4ai.ycc.domain.account.service.impl;

import com.ai4ai.ycc.config.security.JwtTokenProvider;
import com.ai4ai.ycc.domain.account.dto.request.SignUpRequestDto;
import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.account.repository.AccountRepository;
import com.ai4ai.ycc.domain.account.service.AccountService;
import com.ai4ai.ycc.error.code.AccountErrorCode;
import com.ai4ai.ycc.error.code.CommonErrorCode;
import com.ai4ai.ycc.error.code.ErrorCode;
import com.ai4ai.ycc.error.exception.ErrorException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class AccountServiceImpl implements AccountService {

    private final AccountRepository accountRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

    @Override
    public void signUp(SignUpRequestDto requestDto) {
        String id = requestDto.getId();
        String phone = requestDto.getPhone();
        String password = passwordEncoder.encode(requestDto.getPassword());

        if (accountRepository.existsById(id)) {
            throw new ErrorException(AccountErrorCode.ID_DUPLICATION);
        }
        if (accountRepository.existsByPhone(phone)) {
            throw new ErrorException(AccountErrorCode.PHONE_DUPLICATION);
        }

        Account account = Account.builder()
                .id(id)
                .password(password)
                .phone(phone)
                .build();

        accountRepository.save(account);
    }

    @Override
    public void checkId(String id) {
        if (accountRepository.existsById(id)) {
            throw new ErrorException(AccountErrorCode.ID_DUPLICATION);
        }
    }

    @Override
    public void checkPhone(String phone) {
        if (accountRepository.existsByPhone(phone)) {
            throw new ErrorException(AccountErrorCode.PHONE_DUPLICATION);
        }
    }

    @Override
    public String signIn(String id, String password) {
        Account account = accountRepository.findById(id)
                .orElseThrow(() -> new ErrorException(AccountErrorCode.ACCOUNT_NOT_FOUND));

        if (!passwordEncoder.matches(password, account.getPassword())) {
            throw new ErrorException(CommonErrorCode.BAD_REQUEST);
        }

        String token = jwtTokenProvider.createAccessToken(account.getId());

        return token;
    }

}
