package com.ai4ai.ycc.domain.medicine.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ai4ai.ycc.common.annotation.LoginUser;
import com.ai4ai.ycc.common.response.ResponseService;
import com.ai4ai.ycc.common.response.Result;
import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDetailDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDto;
import com.ai4ai.ycc.domain.medicine.service.MedicineService;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.profile.service.ProfileService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/medicine")
@RequiredArgsConstructor
@Slf4j
public class MedicineController {

    private final ResponseService responseService;
    private final MedicineService medicineService;
    private final ProfileService profileService;

    @GetMapping("/search")
    public ResponseEntity<Result> searchMedicine(@RequestParam String type, @RequestParam String query, @RequestParam Long profileLinkSeq, @LoginUser
        Account account){
        Profile profile=profileService.getProfile(account, profileLinkSeq);

        List<MedicineDto> output = null;
        if(type.equals("text")){
            output=medicineService.searchMedicineByText(query,profile);
        }else if(type.equals("edi")){
            output=medicineService.searchMedicineByEdi(query,profile);
        }else{
            output = medicineService.searchMedicineByItemseq(query,profile);
        }
        return ResponseEntity.ok()
            .body(responseService.getListResult(output));
    }

    @GetMapping("/detail/{item_seq}")
    public ResponseEntity<Result> showDetail(@PathVariable long item_seq) {
        MedicineDetailDto medicine= medicineService.showDetail(item_seq);
        return ResponseEntity.ok()
                .body(responseService.getSingleResult(medicine));
    }

    @GetMapping("/test")
    public ResponseEntity<Result> test() {
        return ResponseEntity.ok()
                .body(responseService.getSuccessResult());
    }

}
