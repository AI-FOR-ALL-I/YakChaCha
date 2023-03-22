package com.ai4ai.ycc.domain.medicine.service.impl;

import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Service;

import com.ai4ai.ycc.domain.medicine.dto.MedicineDetailDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDto;
import com.ai4ai.ycc.domain.medicine.entity.Medicine;
import com.ai4ai.ycc.domain.medicine.entity.MedicineDetail;
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
                    .id(medicine.getId())
                    .img(medicine.getImg())
                    .itemName(medicine.getItemName())
                    .itemSeq(medicine.getItemSeq())
                .build());
        }
        return medicineDtoList;
    }

    @Override
    public MedicineDetailDto showDetail(long itemSeq) {
        MedicineDetailDto medicineDetailDto=null;
        MedicineDetail medicineDetail = medicineDetailRepository.findByItemSeq(itemSeq);
        Medicine medicine = medicineRepository.getByItemSeq(itemSeq);
        medicineDetailDto.builder()
            .chart(medicine.getChart())
            .etcOtcCode(medicine.getEtcOtcCode())
            .entpName(medicine.getEntpName())
            .changeDate(medicine.getChangeDate())
            .eeDocData(medicineDetail.getEeDocData())
            .ingrName(medicine.getIngrName())
            .itemPermitDate(medicine.getItemPermitDate())
            .classNo(medicine.getClassNo())
            .nbDocData(medicineDetail.getNbDocData())
            .mainItemIngr(medicine.getMainItemIngr())
            .packUnit(medicine.getPackUnit())
            .storageMethod(medicine.getStorageMethod())
            .typeCode(medicine.getTypeCode())
            .udDocData(medicineDetail.getUdDocData())
            .validTerm(medicine.getValidTerm())
            .itemSeq(itemSeq)
            .itemName(medicine.getItemName())
            .img(medicine.getImg())
            .build();

        return medicineDetailDto;
    }
}
