package com.ai4ai.ycc.domain.profile.service.impl;

import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.dto.request.CreateProfileRequestDto;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.profile.entity.ProfileLink;
import com.ai4ai.ycc.domain.profile.repository.ProfileLinkRepository;
import com.ai4ai.ycc.domain.profile.repository.ProfileRepository;
import com.ai4ai.ycc.domain.profile.service.ProfileService;
import com.ai4ai.ycc.error.code.ProfileErrorCode;
import com.ai4ai.ycc.error.code.ProfileLinkErrorCode;
import com.ai4ai.ycc.error.exception.ErrorException;
import com.ai4ai.ycc.util.DateUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.swing.*;
import java.time.LocalDate;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProfileServiceImpl implements ProfileService {
    private final ProfileRepository profileRepository;
    private final ProfileLinkRepository profileLinkRepository;
    private final DateUtil dateUtil;

    @Override
    public Profile createProfile(Account account, CreateProfileRequestDto requestDto) {
        log.info("[createProfile] 본인 프로필 생성");

        String name = requestDto.getName();
        String gender = requestDto.getGender();
        boolean pregnancy = requestDto.isPregnancy();
        LocalDate birthDate = dateUtil.convertToDateFormat(requestDto.getBirthDate());

        Profile profile = Profile.builder()
                .name(name)
                .gender(gender)
                .pregnancy(pregnancy)
                .birthDate(birthDate)
                .build();

        profileRepository.save(profile);

        log.info("[createProfile] 본인 프로필 생성 완료");
        return profile;
    }

    @Override
    public Profile getProfile(Account account, long profileLinkSeq) {
        ProfileLink profileLink = profileLinkRepository.findByAccountAndProfileLinkSeqAndDelYn(account, profileLinkSeq, "N")
                .orElseThrow(() -> new ErrorException(ProfileLinkErrorCode.NOT_FOUND_PROFILE_LINK));
        log.info("[getProfile] 현재 프로필: {}", profileLink.getProfile());
        return profileLink.getProfile();
    }

}
