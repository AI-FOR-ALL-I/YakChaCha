package com.ai4ai.ycc.domain.medicine.service;

import java.util.List;

import com.ai4ai.ycc.domain.medicine.dto.MedicineDetailDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDto;

public interface MedicineService {
    List<MedicineDto> searchMedicine(String input);
    MedicineDetailDto showDetail(long itemSeq);
}
