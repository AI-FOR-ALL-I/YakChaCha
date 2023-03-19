package com.ai4ai.ycc.domain.account.service;

import com.ai4ai.ycc.domain.account.dto.request.SignUpRequestDto;

public interface AccountService {

    void signUp(SignUpRequestDto requestDto);

}
