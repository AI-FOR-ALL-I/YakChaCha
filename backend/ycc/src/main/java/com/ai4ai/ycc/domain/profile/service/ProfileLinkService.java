package com.ai4ai.ycc.domain.profile.service;

import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.dto.request.CreateProfileRequestDto;
import com.ai4ai.ycc.domain.profile.dto.request.ModifyProfileRequestDto;
import com.ai4ai.ycc.domain.profile.dto.response.ProfileResponseDto;
import com.ai4ai.ycc.domain.profile.entity.Profile;

import java.util.List;

public interface ProfileLinkService {

    void createProfileLink(Account account, Profile profile, CreateProfileRequestDto requestDto);
    ProfileResponseDto getProfile(Account account, long profileLinkSeq);
    List<ProfileResponseDto> getProfileList(Account account);

    void modifyProfile(Account account, ModifyProfileRequestDto requestDto);

    void removeProfile(Account account, long profileLinkSeq);
}
