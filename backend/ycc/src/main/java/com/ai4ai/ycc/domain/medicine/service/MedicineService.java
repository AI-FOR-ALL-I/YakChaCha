package com.ai4ai.ycc.domain.medicine.service;

import java.util.List;

import com.ai4ai.ycc.domain.medicine.dto.MedicineDetailDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDto;
import com.ai4ai.ycc.domain.profile.entity.Profile;

public interface MedicineService {
    List<MedicineDto> searchMedicineByText(String input, Profile profile);

    MedicineDetailDto showDetail(long itemSeq);

    List<MedicineDto> searchMedicineByEdi(String query, Profile profile);

    List<MedicineDto> searchMedicineByItemseq(String query,Profile profile);
}
