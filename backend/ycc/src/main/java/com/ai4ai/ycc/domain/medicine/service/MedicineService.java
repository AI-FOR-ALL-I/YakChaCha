package com.ai4ai.ycc.domain.medicine.service;

import java.util.List;

import com.ai4ai.ycc.domain.medicine.dto.MedicineDetailDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineTakingDto;
import com.ai4ai.ycc.domain.medicine.dto.RegistRequestDto;
import com.ai4ai.ycc.domain.profile.entity.Profile;

public interface MedicineService {
    Boolean regist(List<RegistRequestDto> requestDto, Profile profile);


    List<MedicineDto> searchMedicineByText(String input, Profile profile);

    MedicineDetailDto showDetail(long itemSeq);

    List<MedicineDto> searchMedicineByEdi(String query, Profile profile);

    List<MedicineDto> searchMedicineByItemseq(String query,Profile profile);

    List<MedicineTakingDto> searchTakingMedicine(Profile profile);
}
