package com.ai4ai.ycc.domain.profile.service;

import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.dto.request.AcceptLinkRequestDto;
import com.ai4ai.ycc.domain.profile.dto.request.SendLinkRequestDto;
import com.ai4ai.ycc.domain.profile.dto.request.CreateProfileRequestDto;
import com.ai4ai.ycc.domain.profile.dto.request.ModifyProfileRequestDto;
import com.ai4ai.ycc.domain.profile.dto.response.ConfirmLinkResponseDto;
import com.ai4ai.ycc.domain.profile.dto.response.FindAuthNumberResponseDto;
import com.ai4ai.ycc.domain.profile.dto.response.ProfileResponseDto;
import com.ai4ai.ycc.domain.profile.entity.Profile;

import java.util.List;

public interface ProfileLinkService {

    void createProfileLink(Account account, Profile profile, CreateProfileRequestDto requestDto);
    ProfileResponseDto getProfile(Account account, long profileLinkSeq);
    List<ProfileResponseDto> getProfileList(Account account);

    void modifyProfile(Account account, long profileLinkSeq, ModifyProfileRequestDto requestDto);

    void removeProfile(Account account, long profileLinkSeq);

    void removeAllProfile(Account account);

    void sendLink(Account sender, SendLinkRequestDto requestDto);

    ConfirmLinkResponseDto confirmLink(Account account, long senderAccountSeq);

    void acceptLink(Account account, long senderAccountSeq, AcceptLinkRequestDto requestDto);

    FindAuthNumberResponseDto findAuthNumber(Account account, long senderAccountSeq);
}
