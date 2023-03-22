package com.ai4ai.ycc.domain.account.service;

import com.ai4ai.ycc.domain.account.dto.request.SignInRequestDto;
import com.ai4ai.ycc.domain.account.dto.response.SignInResponseDto;
import com.ai4ai.ycc.domain.account.entity.Account;

public interface AccountService {

    SignInResponseDto signIn(SignInRequestDto requestDto);

    void signOut(Account account);

}
