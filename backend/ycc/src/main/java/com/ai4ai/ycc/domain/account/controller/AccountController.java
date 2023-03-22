package com.ai4ai.ycc.domain.account.controller;

import com.ai4ai.ycc.common.annotation.LoginUser;
import com.ai4ai.ycc.common.response.ResponseService;
import com.ai4ai.ycc.common.response.Result;
import com.ai4ai.ycc.domain.account.dto.request.SignInRequestDto;
import com.ai4ai.ycc.domain.account.dto.response.SignInResponseDto;
import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.account.service.AccountService;
import com.ai4ai.ycc.domain.profile.service.ProfileLinkService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/account")
@RequiredArgsConstructor
@Slf4j
public class AccountController {

    private final ResponseService responseService;
    private final AccountService accountService;
    private final ProfileLinkService profileLinkService;

    @PostMapping("/sign-in")
    public ResponseEntity<Result> signIn(@RequestBody SignInRequestDto requestDto) {
        SignInResponseDto responseDto = accountService.signIn(requestDto);
        return ResponseEntity.ok()
                .body(responseService.getSingleResult(responseDto));
    }

    @PutMapping("/sign-out")
    public ResponseEntity<Result> signOut(@LoginUser Account account) {
        accountService.signOut(account);
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

    @PutMapping("withdrawl")
    public ResponseEntity<Result> withdrawl(@LoginUser Account account) {
        profileLinkService.removeAllProfile(account);
        accountService.withdrawl(account);
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

}
