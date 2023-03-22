package com.ai4ai.ycc.domain.profile.service;

import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.dto.request.CreateProfileRequestDto;
import com.ai4ai.ycc.domain.profile.dto.response.ProfileResponseDto;
import com.ai4ai.ycc.domain.profile.entity.Profile;

import java.util.List;

public interface ProfileLinkService {

    void createProfileLink(Account account, Profile profile, CreateProfileRequestDto requestDto);
    List<ProfileResponseDto> getProfileList(Account account);
}
