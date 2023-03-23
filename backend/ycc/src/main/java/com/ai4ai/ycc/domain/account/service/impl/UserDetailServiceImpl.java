package com.ai4ai.ycc.domain.account.service.impl;

import com.ai4ai.ycc.domain.account.repository.AccountRepository;
import com.ai4ai.ycc.error.code.AccountErrorCode;
import com.ai4ai.ycc.error.exception.ErrorException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserDetailServiceImpl implements UserDetailsService {

    private final AccountRepository accountRepository;

    @Override
    public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
        return accountRepository.findByIdAndDelYn(id, "N").orElseThrow(() -> new ErrorException(AccountErrorCode.ACCOUNT_NOT_FOUND));
    }

}
