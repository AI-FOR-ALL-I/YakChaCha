package com.ai4ai.ycc.domain.profile.service;

import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.dto.request.CreateProfileRequestDto;
import com.ai4ai.ycc.domain.profile.entity.Profile;

public interface ProfileService {


    Profile createProfile(Account account, CreateProfileRequestDto requestDto);

    Profile getProfile(Account account, long profileLinkSeq);
}
