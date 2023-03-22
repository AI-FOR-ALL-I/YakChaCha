package com.ai4ai.ycc.domain.profile.service.impl;

import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.dto.request.CreateProfileRequestDto;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.profile.entity.ProfileLink;
import com.ai4ai.ycc.domain.profile.repository.ProfileLinkRepository;
import com.ai4ai.ycc.domain.profile.repository.ProfileRepository;
import com.ai4ai.ycc.domain.profile.service.ProfileLinkService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProfileLinkServiceImpl implements ProfileLinkService {

    private final ProfileLinkRepository profileLinkRepository;

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
}
