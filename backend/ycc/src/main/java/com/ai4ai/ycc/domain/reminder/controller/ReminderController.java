package com.ai4ai.ycc.domain.reminder.controller;

import com.ai4ai.ycc.common.annotation.LoginUser;
import com.ai4ai.ycc.common.response.ResponseService;
import com.ai4ai.ycc.common.response.Result;
import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.profile.service.ProfileService;
import com.ai4ai.ycc.domain.reminder.dto.request.CreateReminderRequestDto;
import com.ai4ai.ycc.domain.reminder.dto.request.TakeMedicineRequestDto;
import com.ai4ai.ycc.domain.reminder.dto.response.ReminderDetailResponseDto;
import com.ai4ai.ycc.domain.reminder.dto.response.ReminderResponseDto;
import com.ai4ai.ycc.domain.reminder.service.ReminderService;
import io.netty.util.AbstractReferenceCounted;
import lombok.RequiredArgsConstructor;
import lombok.extern.java.Log;
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
        Profile profile = profileService.getProfile(account, requestDto.getProfileLinkSeq());
        log.info("[getReminderList] Profile: {}", profile);
        reminderService.createReminder(profile, requestDto);
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

    @GetMapping("/{profileLinkSeq}")
    public ResponseEntity<Result> getReminderList(@LoginUser Account account, @PathVariable long profileLinkSeq) {
        Profile profile = profileService.getProfile(account, profileLinkSeq);
        List<ReminderResponseDto> resultList = reminderService.getReminderList(profile);
        return ResponseEntity.ok()
                .body(responseService.getListResult(resultList));
    }

    @GetMapping("/{profileLinkSeq}/{reminderSeq}")
    public ResponseEntity<Result> getReminderDetail(@LoginUser Account account, @PathVariable long profileLinkSeq, @PathVariable long reminderSeq) {
        Profile profile = profileService.getProfile(account, profileLinkSeq);
        ReminderDetailResponseDto result = reminderService.getReminderDetail(profile, reminderSeq);
        return ResponseEntity.ok()
                .body(responseService.getSingleResult(result));
    }

    @GetMapping("/{profileLinkSeq}/{reminderSeq}/records/{month}")
    public ResponseEntity<Result> getTakenRecords(@LoginUser Account account, @PathVariable long profileLinkSeq, @PathVariable long reminderSeq, @PathVariable String month) {
        Profile profile = profileService.getProfile(account, profileLinkSeq);
        List<Integer> result = reminderService.getTakenRecords(profile, reminderSeq, month);
        return ResponseEntity.ok()
                .body(responseService.getListResult(result));
    }

    @PutMapping("/take")
    public ResponseEntity<Result> takeMedicine(@LoginUser Account account, @RequestBody TakeMedicineRequestDto requestDto) {
        Profile profile = profileService.getProfile(account, requestDto.getProfileLinkSeq());
        reminderService.takeMedicine(profile, requestDto.getReminderSeq());
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }


}
