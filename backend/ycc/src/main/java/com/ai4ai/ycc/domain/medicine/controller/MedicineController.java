package com.ai4ai.ycc.domain.medicine.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ai4ai.ycc.common.response.ResponseService;
import com.ai4ai.ycc.common.response.Result;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDetailDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDto;
import com.ai4ai.ycc.domain.medicine.service.MedicineService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/medicine")
@RequiredArgsConstructor
@Slf4j
public class MedicineController {

    private final ResponseService responseService;
    private final MedicineService medicineService;

    @GetMapping("/search/{input}")
    public ResponseEntity<Result> searchMedicine(@PathVariable String input){
        List<MedicineDto> output=medicineService.searchMedicine(input);
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
