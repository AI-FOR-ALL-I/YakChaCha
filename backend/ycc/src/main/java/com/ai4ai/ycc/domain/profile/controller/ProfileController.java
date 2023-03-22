package com.ai4ai.ycc.domain.profile.controller;

import com.ai4ai.ycc.common.annotation.LoginUser;
import com.ai4ai.ycc.common.response.ResponseService;
import com.ai4ai.ycc.common.response.Result;
import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.dto.request.CreateProfileRequestDto;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.profile.repository.ProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;

@RestController
@RequestMapping("/profile")
@RequiredArgsConstructor
public class ProfileController {

    private final ResponseService responseService;
    private final ProfileRepository profileRepository;

    @PostMapping
    public ResponseEntity<Result> createProfile(@LoginUser Account account, @RequestBody CreateProfileRequestDto requestDto) {
        Profile profile = Profile.builder()
                .name("사용자1")
                .gender("M")
                .pregnancy(false)
                .birthDate(LocalDate.now())
                .build();
        profileRepository.save(profile);
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

}
