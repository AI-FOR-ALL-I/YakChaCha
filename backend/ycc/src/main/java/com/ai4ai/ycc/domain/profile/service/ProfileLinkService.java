package com.ai4ai.ycc.domain.profile.service;

import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.dto.response.AccountResponseDto;
import com.ai4ai.ycc.domain.profile.dto.request.*;
import com.ai4ai.ycc.domain.profile.dto.response.ConfirmLinkResponseDto;
import com.ai4ai.ycc.domain.profile.dto.response.FindAuthNumberResponseDto;
import com.ai4ai.ycc.domain.profile.dto.response.ProfileResponseDto;
import com.ai4ai.ycc.domain.profile.dto.response.ReceiverProfileResponseDto;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.profile.entity.ProfileLink;

import java.util.List;

public interface ProfileLinkService {

    void createProfileLink(Account account, Profile profile, CreateProfileRequestDto requestDto);
    ProfileResponseDto getProfile(Account account, long profileLinkSeq);
    List<ProfileResponseDto> getProfileList(Account account);

    void modifyProfile(Account account, long profileLinkSeq, ModifyProfileRequestDto requestDto);

    void removeProfile(Account account, long profileLinkSeq);

    void removeAllProfile(Account account);
    void remove(ProfileLink profileLink);

    void sendLink(Account sender, SendLinkRequestDto requestDto) ;

    ConfirmLinkResponseDto confirmLink(Account account, long senderAccountSeq);

    void acceptLink(Account account, long senderAccountSeq, AcceptLinkRequestDto requestDto);

    FindAuthNumberResponseDto findAuthNumber(Account account, long senderAccountSeq);

    void checkAuthNumber(Account account, CheckAuthNumberRequestDto requestDto);

    List<ReceiverProfileResponseDto> getRecieverProfileList(Account account);

    void linkProfiles(Account account, List<LinkProfileRequestDto> requestDto);

    List<AccountResponseDto> getLinkedAccount(Profile profile);

    void unlink(Account account, long profileLinkSeq);
}
