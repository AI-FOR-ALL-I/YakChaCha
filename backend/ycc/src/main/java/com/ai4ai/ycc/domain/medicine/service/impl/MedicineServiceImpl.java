package com.ai4ai.ycc.domain.medicine.service.impl;

import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Service;

import com.ai4ai.ycc.domain.medicine.dto.MedicineDetailDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDto;
import com.ai4ai.ycc.domain.medicine.entity.Medicine;
import com.ai4ai.ycc.domain.medicine.repository.MedicineDetailRepository;
import com.ai4ai.ycc.domain.medicine.repository.MedicineRepository;
import com.ai4ai.ycc.domain.medicine.service.MedicineService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class MedicineServiceImpl implements MedicineService {
    final MedicineRepository medicineRepository;
    final MedicineDetailRepository medicineDetailRepository;

    @Override
    public List<MedicineDto> searchMedicine(String input) {
        List<MedicineDto> medicineDtoList = new ArrayList<>();
        List<Medicine> medicineList = medicineRepository.findByItemNameLike("%"+input+"%");
        for(Medicine medicine: medicineList){
            medicineDtoList.add(MedicineDto.builder()
                    .itemSeq(medicine.getItemSeq())
                    .img(medicine.getImg())
                    .itemName(medicine.getItemName())
                    .medicineSeq(medicine.getMedicineSeq())
                .build());
        }
        return medicineDtoList;
    }

    @Override
    public MedicineDetailDto showDetail(long itemSeq) {
        System.out.println(itemSeq+"의 itemSeq를 가진 약 검색");
        Medicine medicine = medicineRepository.findByItemSeq(itemSeq);

        MedicineDetailDto medicineDetailDto=MedicineDetailDto.builder()
            .chart(medicine.getChart())
            .etcOtcCode(medicine.getEtcOtcCode())
            .entpName(medicine.getEntpName())
            .changeDate(medicine.getChangeDate())
            .medicineSeq(medicine.getMedicineSeq())
            .ingrName(medicine.getIngrName())
            .itemPermitDate(medicine.getItemPermitDate())
            .classNo(medicine.getClassNo())
            .mainItemIngr(medicine.getMainItemIngr())
            .packUnit(medicine.getPackUnit())
            .storageMethod(medicine.getStorageMethod())
            .typeCode(medicine.getTypeCode())
            .validTerm(medicine.getValidTerm())
            .itemSeq(itemSeq)
            .itemName(medicine.getItemName())
            .img(medicine.getImg())
            .udDocData(medicine.getDetail().getUdDocData())
            .nbDocData(medicine.getDetail().getNbDocData())
            .eeDocData(medicine.getDetail().getEeDocData())
            .materialName(medicine.getDetail().getMaterialName())
            .build();

        return medicineDetailDto;
    }
}
