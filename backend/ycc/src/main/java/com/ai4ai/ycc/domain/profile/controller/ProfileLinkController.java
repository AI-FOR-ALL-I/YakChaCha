package com.ai4ai.ycc.domain.profile.controller;

import com.ai4ai.ycc.common.annotation.LoginUser;
import com.ai4ai.ycc.common.response.ResponseService;
import com.ai4ai.ycc.common.response.Result;
import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.dto.request.CheckAuthNumberRequestDto;
import com.ai4ai.ycc.domain.profile.dto.request.LinkProfileRequestDto;
import com.ai4ai.ycc.domain.profile.dto.request.SendLinkRequestDto;
import com.ai4ai.ycc.domain.profile.dto.request.AcceptLinkRequestDto;
import com.ai4ai.ycc.domain.profile.dto.response.ConfirmLinkResponseDto;
import com.ai4ai.ycc.domain.profile.dto.response.FindAuthNumberResponseDto;
import com.ai4ai.ycc.domain.profile.dto.response.ReceiverProfileResponseDto;
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
@RequestMapping("/links")
@RequiredArgsConstructor
@Slf4j
public class ProfileLinkController {

    private final ResponseService responseService;
    private final ProfileService profileService;
    private final ProfileLinkService profileLinkService;

    @PostMapping
    public ResponseEntity<Result> sendLink(@LoginUser Account account, @RequestBody SendLinkRequestDto requestDto) {
        log.info("[sendLink] 프로필 연동 요청 전송 API 호출");
        profileLinkService.sendLink(account, requestDto);
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

    @GetMapping("/sender/{senderAccountSeq}")
    public ResponseEntity<Result> confirmLink(@LoginUser Account account, @PathVariable long senderAccountSeq) {
        log.info("[receiveLink] 프로필 연동 요청 확인 API 호출");
        ConfirmLinkResponseDto result = profileLinkService.confirmLink(account, senderAccountSeq);
        return ResponseEntity.ok()
                .body(responseService.getSingleResult(result));
    }

    @PutMapping("/sender/{senderAccountSeq}")
    public ResponseEntity<Result> acceptLink(@LoginUser Account account, @PathVariable long senderAccountSeq, @RequestBody AcceptLinkRequestDto requestDto) {
        log.info("[acceptLink] 프로필 연동 요청 수락 API 호출");
        profileLinkService.acceptLink(account, senderAccountSeq, requestDto);
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

    @GetMapping("/sender/{senderAccountSeq}/auth")
    public ResponseEntity<Result> findAuthNumber(@LoginUser Account account, @PathVariable long senderAccountSeq) {
        log.info("[findAuthNumber] 프로필 연동 인증번호 조회 API 호출");
        FindAuthNumberResponseDto result = profileLinkService.findAuthNumber(account, senderAccountSeq);
        return ResponseEntity.ok()
                .body(responseService.getSingleResult(result));
    }

    @PutMapping("/auth")
    public ResponseEntity<Result> checkAuthNumber(@LoginUser Account account, @RequestBody CheckAuthNumberRequestDto requestDto) {
        log.info("[checkAuthNumber] 프로필 연동 인증번호 확인 API 호출");
        profileLinkService.checkAuthNumber(account, requestDto);
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

    @GetMapping("/profiles")
    public ResponseEntity<Result> getReceiverProfileList(@LoginUser Account account) {
        log.info("[getReceiverProfileList] 프로필 연동 프로필 목록 조회 API 호출");
        List<ReceiverProfileResponseDto> profiles = profileLinkService.getRecieverProfileList(account);
        return ResponseEntity.ok()
                .body(responseService.getListResult(profiles));
    }

    @PostMapping("/profiles")
    public ResponseEntity<Result> linkProfiles(@LoginUser Account account, @RequestBody List<LinkProfileRequestDto> requestDto) {
        log.info("[linkProfiles] 프로필 연동 등록 API 호출");
        profileLinkService.linkProfiles(account, requestDto);
//        List<ProfileResponseDto> profiles = profileLinkService.getRecieverProfileList(account);
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

    @PutMapping("/{profileLinkSeq}/delete")
    public ResponseEntity<Result> unlink(@LoginUser Account account, @PathVariable long profileLinkSeq) {
        log.info("[unlink] 프로필 연동 끊기 API 호출");
        profileLinkService.unlink(account, profileLinkSeq);
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }


}
