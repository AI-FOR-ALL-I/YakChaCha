package com.ai4ai.ycc.domain.medicine.controller;

import java.util.List;

import com.ai4ai.ycc.domain.medicine.entity.MyMedicine;
import com.ai4ai.ycc.domain.reminder.entity.ReminderMedicine;
import com.ai4ai.ycc.domain.reminder.service.ReminderService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ai4ai.ycc.common.annotation.LoginUser;
import com.ai4ai.ycc.common.response.ResponseService;
import com.ai4ai.ycc.common.response.Result;
import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.medicine.dto.MedicineByTagDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDetailDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDto;
import com.ai4ai.ycc.domain.medicine.dto.MyMedicineDto;
import com.ai4ai.ycc.domain.medicine.dto.RegistRequestDto;
import com.ai4ai.ycc.domain.medicine.dto.TagDto;
import com.ai4ai.ycc.domain.medicine.service.MedicineService;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.profile.service.ProfileService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/profiles/{profileLinkSeq}/medicine")
@RequiredArgsConstructor
@Slf4j
public class MedicineController {

    private final ResponseService responseService;
    private final MedicineService medicineService;
    private final ProfileService profileService;
    private final ReminderService reminderService;

    // 약 검색
    @GetMapping("/search")
    public ResponseEntity<Result> searchMedicine(@RequestParam String type, @RequestParam List<String> query, @PathVariable long profileLinkSeq, @LoginUser
        Account account){
        Profile profile=profileService.getProfile(account, profileLinkSeq);

        List<MedicineDto> output = null;
        output = medicineService.searchMedicine(query,profile,type);

        return ResponseEntity.ok()
            .body(responseService.getListResult(output));
    }

    // 약 상세정보
    @GetMapping("/detail/{item_seq}")
    public ResponseEntity<Result> showDetail(@PathVariable("item_seq") long itemSeq, @PathVariable("profileLinkSeq") long profileLinkSeq, @LoginUser
    Account account) {
        Profile profile=profileService.getProfile(account, profileLinkSeq);
        MedicineDetailDto medicine= medicineService.showDetail(itemSeq,profile);
        return ResponseEntity.ok()
                .body(responseService.getSingleResult(medicine));
    }

    // 내 약 리스트
    @GetMapping("/my")
    public ResponseEntity<Result> showMyMedicineList(@PathVariable long profileLinkSeq, @LoginUser Account account, @RequestParam boolean now){
        Profile profile=profileService.getProfile(account, profileLinkSeq);
        List<MyMedicineDto> output = medicineService.searchMyMedicine(profile,now);
        return ResponseEntity.ok()
            .body(responseService.getListResult(output));
    }

    // 내 약 등록
    @PostMapping("/my")
    public ResponseEntity<Result> registMedicine(@RequestBody List<RegistRequestDto> requestDto, @PathVariable long profileLinkSeq, @LoginUser Account account) {
        Profile profile=profileService.getProfile(account, profileLinkSeq);
        medicineService.regist(requestDto,profile);
        return ResponseEntity.ok()
            .body(responseService.getSuccessResult());
    }

    // 내 약 삭제
    @PutMapping("/my")
    public ResponseEntity<Result> deleteMyMedicine(@PathVariable long profileLinkSeq, @LoginUser Account account, @RequestParam long myMedicineSeq) {
        Profile profile=profileService.getProfile(account, profileLinkSeq);
        MyMedicine myMedicine = medicineService.deleteMyMedicine(profile,myMedicineSeq);
        reminderService.removeByMyMedicine(myMedicine);
        return ResponseEntity.ok()
            .body(responseService.getSuccessResult());
    }

    // 태그 리스트 출력
    @GetMapping("/tag")
    public ResponseEntity<Result> showTags(@PathVariable long profileLinkSeq, @LoginUser Account account) {
        Profile profile=profileService.getProfile(account, profileLinkSeq);
        List<TagDto> response = medicineService.showTags(profile);
        return ResponseEntity.ok()
            .body(responseService.getSingleResult(response));
    }

    // 태그로 내 약 검색
    @PostMapping("/tag/search")
    public ResponseEntity<Result> searchMedicineByTags(@PathVariable long profileLinkSeq, @RequestBody List<String> tagList, @LoginUser Account account) {
        Profile profile=profileService.getProfile(account, profileLinkSeq);
        List<MedicineByTagDto> response = medicineService.searchByTags(profile,tagList);
        return ResponseEntity.ok()
            .body(responseService.getSingleResult(response));
    }

    // 태그 삭제
    @PutMapping("/tag/delete")
    public ResponseEntity<Result> deleteTags(@PathVariable long profileLinkSeq, @LoginUser Account account, @RequestParam String tagName) {
        Profile profile=profileService.getProfile(account, profileLinkSeq);
        medicineService.deleteTags(profile,tagName);
        return ResponseEntity.ok()
            .body(responseService.getSuccessResult());
    }



}
