package com.ai4ai.ycc.domain.profile.controller;

import com.ai4ai.ycc.common.annotation.LoginUser;
import com.ai4ai.ycc.common.response.ResponseService;
import com.ai4ai.ycc.common.response.Result;
import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.dto.request.CreateProfileRequestDto;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.profile.repository.ProfileRepository;
import com.ai4ai.ycc.domain.profile.service.ProfileLinkService;
import com.ai4ai.ycc.domain.profile.service.ProfileService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;

@RestController
@RequestMapping("/profile")
@RequiredArgsConstructor
@Slf4j
public class ProfileController {

    private final ResponseService responseService;
    private final ProfileService profileService;
    private final ProfileLinkService profileLinkService;
    private final ProfileRepository profileRepository;

    @PostMapping
    public ResponseEntity<Result> createProfile(@LoginUser Account account, @RequestBody CreateProfileRequestDto requestDto) {
        log.info("[createProfile] 프로필 생성 API 호출");
        Profile profile = profileService.createProfile(account, requestDto);
        profileLinkService.createProfileLink(account, profile, requestDto);
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

}
