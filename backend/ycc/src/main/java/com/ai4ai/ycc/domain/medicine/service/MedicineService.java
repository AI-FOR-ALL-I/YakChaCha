package com.ai4ai.ycc.domain.medicine.service;

import java.util.List;

import com.ai4ai.ycc.domain.medicine.dto.MedicineByTagDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDetailDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDto;
import com.ai4ai.ycc.domain.medicine.dto.MyMedicineDto;
import com.ai4ai.ycc.domain.medicine.dto.RegistRequestDto;
import com.ai4ai.ycc.domain.medicine.dto.TagDto;
import com.ai4ai.ycc.domain.profile.entity.Profile;

public interface MedicineService {
    void regist(List<RegistRequestDto> requestDto, Profile profile);

    List<MedicineDto> searchMedicine(List<String> input, Profile profile, String type);

    MedicineDetailDto showDetail(long itemSeq, Profile profile);

    List<MyMedicineDto> searchMyMedicine(Profile profile, boolean now);

	List<TagDto> showTags(Profile profile);

	List<MedicineByTagDto> searchByTags(Profile profile, List<String> tagList);

	void deleteTags(Profile profile, String tagName);

	void deleteMyMedicine(Profile profile, long myMedicineSeq);
}
