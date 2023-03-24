package com.ai4ai.ycc.domain.reminder.controller;

import com.ai4ai.ycc.common.annotation.LoginUser;
import com.ai4ai.ycc.common.response.ResponseService;
import com.ai4ai.ycc.common.response.Result;
import com.ai4ai.ycc.domain.account.dto.request.SignInRequestDto;
import com.ai4ai.ycc.domain.account.dto.response.SignInResponseDto;
import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.profile.service.ProfileService;
import com.ai4ai.ycc.domain.reminder.dto.request.CreateReminderRequestDto;
import com.ai4ai.ycc.domain.reminder.dto.response.ReminderResponseDto;
import com.ai4ai.ycc.domain.reminder.service.ReminderService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/reminder")
@RequiredArgsConstructor
@Slf4j
public class ReminderController {

    private final ProfileService profileService;
    private final ResponseService responseService;
    private final ReminderService reminderService;

    @PostMapping
    public ResponseEntity<Result> createReminder(@LoginUser Account account, @RequestBody CreateReminderRequestDto requestDto) {
        Profile profile = profileService.getProfile(requestDto.getProfileSeq());
        reminderService.createReminder(account, profile, requestDto);
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

    @GetMapping
    public ResponseEntity<Result> getReminderList(@LoginUser Account account) {
        List<ReminderResponseDto> resultList = reminderService.getReminderList(account);
        return ResponseEntity.ok()
                .body(responseService.getListResult(resultList));
    }

}
