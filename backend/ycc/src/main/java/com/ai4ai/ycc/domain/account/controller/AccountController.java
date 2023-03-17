package com.ai4ai.ycc.domain.account.controller;

import com.ai4ai.ycc.common.response.ResponseService;
import com.ai4ai.ycc.common.response.Result;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/account")
@RequiredArgsConstructor
@Slf4j
public class AccountController {

    private final ResponseService responseService;

    @GetMapping("/test")
    public ResponseEntity<Result> test() {
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

}
