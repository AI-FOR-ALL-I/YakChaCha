package com.ai4ai.ycc.domain.profile.controller;

import com.ai4ai.ycc.common.annotation.LoginUser;
import com.ai4ai.ycc.common.response.ResponseService;
import com.ai4ai.ycc.common.response.Result;
import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.dto.request.CreateProfileRequestDto;
import com.ai4ai.ycc.domain.profile.dto.request.ModifyProfileRequestDto;
import com.ai4ai.ycc.domain.profile.dto.response.AccountResponseDto;
import com.ai4ai.ycc.domain.profile.dto.response.ProfileResponseDto;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.profile.service.ProfileLinkService;
import com.ai4ai.ycc.domain.profile.service.ProfileService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.checkerframework.checker.units.qual.A;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/profiles")
@RequiredArgsConstructor
@Slf4j
public class ProfileController {

    private final ResponseService responseService;
    private final ProfileService profileService;
    private final ProfileLinkService profileLinkService;

    @GetMapping
    public ResponseEntity<Result> getProfileList(@LoginUser Account account) {
        log.info("[getProfileList] 프로필 목록 조회 API 호출 > {}", account);
        List<ProfileResponseDto> result = profileLinkService.getProfileList(account);
        log.info("[getProfileList] result: {}", result);
        return ResponseEntity.ok()
                .body(responseService.getListResult(result));
    }

    @GetMapping("/{profileLinkSeq}")
    public ResponseEntity<Result> getProfile(@LoginUser Account account, @PathVariable long profileLinkSeq) {
        log.info("[getProfile] 프로필 조회 API 호출 > {}", account);
        ProfileResponseDto result = profileLinkService.getProfile(account, profileLinkSeq);
        log.info("[getProfile] result: {}", result);
        return ResponseEntity.ok()
                .body(responseService.getSingleResult(result));
    }

    @PostMapping
    public ResponseEntity<Result> createProfile(@LoginUser Account account, @RequestBody CreateProfileRequestDto requestDto) {
        log.info("[createProfile] 프로필 생성 API 호출");
        Profile profile = profileService.createProfile(account, requestDto);
        profileLinkService.createProfileLink(account, profile, requestDto);
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

    @PutMapping("/{profileLinkSeq}")
    public ResponseEntity<Result> modifyProfile(@LoginUser Account account, @PathVariable long profileLinkSeq, @RequestBody ModifyProfileRequestDto requestDto) {
        log.info("[modifyProfile] 프로필 수정 API 호출");
        profileLinkService.modifyProfile(account, profileLinkSeq, requestDto);
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

    @PutMapping("/{profileLinkSeq}/delete")
    public ResponseEntity<Result> removeProfile(@LoginUser Account account, @PathVariable long profileLinkSeq) {
        log.info("[removeProfile] 본인 프로필 삭제 API 호출");
        profileLinkService.removeProfile(account, profileLinkSeq);
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

    @GetMapping("/{profileLinkSeq}/links")
    public ResponseEntity<Result> getLinkedAccount(@LoginUser Account account, @PathVariable long profileLinkSeq) {
        Profile profile = profileService.getProfile(account, profileLinkSeq);
        List<AccountResponseDto> result = profileLinkService.getLinkedAccount(profile);
        return ResponseEntity.ok()
                .body(responseService.getListResult(result));
    }
}
