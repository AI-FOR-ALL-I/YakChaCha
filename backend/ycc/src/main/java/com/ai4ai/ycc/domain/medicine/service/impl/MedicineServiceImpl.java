package com.ai4ai.ycc.domain.medicine.service.impl;

import java.time.LocalDate;
import java.time.Period;
import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Service;

import com.ai4ai.ycc.domain.medicine.dto.MedicineDetailDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDto;
import com.ai4ai.ycc.domain.medicine.entity.Medicine;
import com.ai4ai.ycc.domain.medicine.repository.MedicineDetailRepository;
import com.ai4ai.ycc.domain.medicine.repository.MedicineRepository;
import com.ai4ai.ycc.domain.medicine.service.MedicineService;
import com.ai4ai.ycc.domain.profile.entity.Profile;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class MedicineServiceImpl implements MedicineService {
    final MedicineRepository medicineRepository;
    final MedicineDetailRepository medicineDetailRepository;

    @Override
    public List<MedicineDto> searchMedicineByText(String input, Profile profile) {
        List<MedicineDto> medicineDtoList = new ArrayList<>();
        List<Medicine> medicineList = medicineRepository.findByItemNameLike("%"+input+"%");
        boolean pregnant = profile.isPregnancy();
        LocalDate birthdate = profile.getBirthDate();
        LocalDate now = LocalDate.now();
        Period period = Period.between(birthdate, now);
        int age = period.getYears();
        boolean young = age<18? true: false;
        boolean old = age>60? true: false;
        for(Medicine medicine: medicineList){
            boolean pregnant_warn = false;
            boolean young_warn = false;
            boolean old_warn = false;
            boolean collide = false;
            List collide_list = new ArrayList<String>();
            
            if(pregnant && medicine.getTypeCode().contains("임")){
                pregnant_warn=true;
            }
            if(young && medicine.getTypeCode().contains("연령")){
                young_warn=true;
            }
            if(old && medicine.getTypeCode().contains("노인")){
                old_warn=true;
            }
            //내약목록 추가하고 collide 여부 파악 추가하기
            medicineDtoList.add(MedicineDto.builder()
                    .itemSeq(medicine.getItemSeq())
                    .img(medicine.getImg())
                    .itemName(medicine.getItemName())
                    .collide(collide)
                    .collide_list(collide_list)
                    .warn_age(young_warn)
                    .warn_old(old_warn)
                    .warn_pregnant(pregnant_warn)
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

    @Override
    public List<MedicineDto> searchMedicineByEdi(String query, Profile profile) {
        return null;
    }

    @Override
    public List<MedicineDto> searchMedicineByItemseq(String query, Profile profile) {
        return null;
    }
}
