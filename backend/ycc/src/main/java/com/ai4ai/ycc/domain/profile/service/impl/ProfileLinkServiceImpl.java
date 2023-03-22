package com.ai4ai.ycc.domain.profile.service.impl;

import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.dto.request.CreateProfileRequestDto;
import com.ai4ai.ycc.domain.profile.dto.response.ProfileResponseDto;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.profile.entity.ProfileLink;
import com.ai4ai.ycc.domain.profile.repository.ProfileLinkRepository;
import com.ai4ai.ycc.domain.profile.repository.ProfileRepository;
import com.ai4ai.ycc.domain.profile.service.ProfileLinkService;
import com.ai4ai.ycc.util.DateUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProfileLinkServiceImpl implements ProfileLinkService {

    private final ProfileLinkRepository profileLinkRepository;
    private final DateUtil dateUtil;

    @Override
    public void createProfileLink(Account account, Profile profile, CreateProfileRequestDto requestDto) {
        log.info("[createProfileLink] 본인 프로필 링크 생성");

        String nickname = requestDto.getNickname();
        int imgCode = requestDto.getImgCode();

        ProfileLink profileLink = ProfileLink.builder()
                .account(account)
                .owner(account)
                .profile(profile)
                .nickname(nickname)
                .imgCode(imgCode)
                .build();

        profileLinkRepository.save(profileLink);
        log.info("[createProfileLink] 본인 프로필 링크 생성 완료");
        
    }

    @Override
    public List<ProfileResponseDto> getProfileList(Account account) {
        log.info("[getProfileList] 프로필 목록 조회");

        List<ProfileLink> profileLinkList = profileLinkRepository.findAllByAccount(account);
        log.info("[getProfileList] ProfileLink 목록 조회 완료 > {}", profileLinkList);
        
        List<ProfileResponseDto> result = new ArrayList<>();

        for (ProfileLink profileLink : profileLinkList) {
            log.info("[getProfileList] Profile 조회 시작");
            Profile profile = profileLink.getProfile();
            log.info("[getProfileList] Profile 조회 완료 > {}", profile);

            boolean isOwner = account.getAccountSeq() == profileLink.getOwner().getAccountSeq();

            log.info("[getProfileList] Profile 추가 시작");
            result.add(ProfileResponseDto.builder()
                            .profileLinkSeq(profileLink.getProfileLinkSeq())
                            .imgCode(profileLink.getImgCode())
                            .nickname(profileLink.getNickname())
                            .name(profile.getName())
                            .gender(profile.getGender())
                            .isPregnancy(profile.isPregnancy())
                            .birthDate(dateUtil.convertToStringType(profile.getBirthDate()))
                            .isOwner(isOwner)
                            .build());
            log.info("[getProfileList] Profile 추가 완료");
        }

        log.info("[getProfileList] 프로필 목록 조회 완료");

        return result;
    }
}
