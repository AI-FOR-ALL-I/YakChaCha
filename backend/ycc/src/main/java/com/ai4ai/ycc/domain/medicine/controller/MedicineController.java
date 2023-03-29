package com.ai4ai.ycc.domain.medicine.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ai4ai.ycc.common.annotation.LoginUser;
import com.ai4ai.ycc.common.response.ResponseService;
import com.ai4ai.ycc.common.response.Result;
import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDetailDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDto;
import com.ai4ai.ycc.domain.medicine.dto.MyMedicineDto;
import com.ai4ai.ycc.domain.medicine.dto.RegistRequestDto;
import com.ai4ai.ycc.domain.medicine.dto.TagDto;
import com.ai4ai.ycc.domain.medicine.entity.Tag;
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

    @GetMapping("/search")
    public ResponseEntity<Result> searchMedicine(@RequestParam String type, @RequestParam String query, @PathVariable Long profileLinkSeq, @LoginUser
        Account account){
        Profile profile=profileService.getProfile(account, profileLinkSeq);

        List<MedicineDto> output = null;
        output = medicineService.searchMedicine(query,profile,type);

        return ResponseEntity.ok()
            .body(responseService.getListResult(output));
    }

    @GetMapping("/detail/{item_seq}")
    public ResponseEntity<Result> showDetail(@PathVariable("item_seq") long item_seq, @PathVariable("profileLinkSeq") Long profileLinkSeq, @LoginUser
    Account account) {
        Profile profile=profileService.getProfile(account, profileLinkSeq);
        MedicineDetailDto medicine= medicineService.showDetail(item_seq,profile);
        return ResponseEntity.ok()
                .body(responseService.getSingleResult(medicine));
    }

    @GetMapping("/my")
    public ResponseEntity<Result> showMyMedicineList(@PathVariable Long profileLinkSeq, @LoginUser Account account, @RequestParam boolean now){
        Profile profile=profileService.getProfile(account, profileLinkSeq);
        List<MyMedicineDto> output = medicineService.searchMyMedicine(profile,now);
        return ResponseEntity.ok()
            .body(responseService.getListResult(output));
    }

    @PostMapping("/my")
    public ResponseEntity<Result> registMedicine(@RequestBody List<RegistRequestDto> requestDto, @PathVariable Long profileLinkSeq, @LoginUser Account account) {
        Profile profile=profileService.getProfile(account, profileLinkSeq);
        Boolean response = medicineService.regist(requestDto,profile);
        return ResponseEntity.ok()
            .body(responseService.getSingleResult(response));
    }

    @GetMapping("/tag")
    public ResponseEntity<Result> showTags(@PathVariable Long profileLinkSeq, @LoginUser Account account) {
        Profile profile=profileService.getProfile(account, profileLinkSeq);
        List<TagDto> response = medicineService.showTags(profile);
        return ResponseEntity.ok()
            .body(responseService.getSingleResult(response));
    }

}
