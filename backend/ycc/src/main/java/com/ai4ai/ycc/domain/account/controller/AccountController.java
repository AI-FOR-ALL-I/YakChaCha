package com.ai4ai.ycc.domain.account.controller;

import com.ai4ai.ycc.common.response.ResponseService;
import com.ai4ai.ycc.common.response.Result;
import com.ai4ai.ycc.domain.account.dto.request.SignUpRequestDto;
import com.ai4ai.ycc.domain.account.service.AccountService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.parameters.P;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/account")
@RequiredArgsConstructor
@Slf4j
public class AccountController {

    private final ResponseService responseService;
    private final AccountService accountService;

    @PostMapping("/sign-up")
    public ResponseEntity<Result> signUp(@RequestBody SignUpRequestDto requestDto) {
        accountService.signUp(requestDto);
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

    @GetMapping("/check/id/{id}")
    public ResponseEntity<Result> checkId(@PathVariable String id) {
        accountService.checkId(id);
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

    @GetMapping("/check/phone/{phone}")
    public ResponseEntity<Result> checkPhone(@PathVariable String phone) {
        accountService.checkPhone(phone);
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }



    @GetMapping("/test")
    public ResponseEntity<Result> test() {
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

}
