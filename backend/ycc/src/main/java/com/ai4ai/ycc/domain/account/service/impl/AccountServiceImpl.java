package com.ai4ai.ycc.domain.account.service.impl;

import com.ai4ai.ycc.domain.account.dto.request.SignUpRequestDto;
import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.account.repository.AccountRepository;
import com.ai4ai.ycc.domain.account.service.AccountService;
import com.ai4ai.ycc.error.ErrorCode;
import com.ai4ai.ycc.error.ErrorException;
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
public class AccountServiceImpl implements AccountService, UserDetailsService {

    private final AccountRepository accountRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return null;
    }

    @Override
    public void signUp(SignUpRequestDto requestDto) {
        String id = requestDto.getId();
        String phone = requestDto.getPhone();
        String password = passwordEncoder.encode(requestDto.getPassword());

        if (accountRepository.existsById(id)) {
            throw new ErrorException(ErrorCode.ID_DUPLICATION);
        }
        if (accountRepository.existsByPhone(phone)) {
            throw new ErrorException(ErrorCode.PHONE_DUPLICATION);
        }

        Account account = Account.builder()
                .id(id)
                .password(password)
                .phone(phone)
                .build();

        accountRepository.save(account);
    }
}
