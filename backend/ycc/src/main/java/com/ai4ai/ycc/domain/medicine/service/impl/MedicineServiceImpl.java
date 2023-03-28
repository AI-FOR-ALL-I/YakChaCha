package com.ai4ai.ycc.domain.medicine.service.impl;

import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;


import org.springframework.stereotype.Service;

import com.ai4ai.ycc.domain.medicine.dto.MedicineDetailDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineTakingDto;
import com.ai4ai.ycc.domain.medicine.dto.RegistRequestDto;
import com.ai4ai.ycc.domain.medicine.entity.Medicine;
import com.ai4ai.ycc.domain.medicine.entity.MyMedicine;
import com.ai4ai.ycc.domain.medicine.entity.MyMedicineHasTag;
import com.ai4ai.ycc.domain.medicine.entity.Tag;
import com.ai4ai.ycc.domain.medicine.repository.CollisionRepository;
import com.ai4ai.ycc.domain.medicine.repository.MedicineDetailRepository;
import com.ai4ai.ycc.domain.medicine.repository.MedicineRepository;
import com.ai4ai.ycc.domain.medicine.repository.MyMedicineHasTagRepository;
import com.ai4ai.ycc.domain.medicine.repository.MyMedicineRepository;
import com.ai4ai.ycc.domain.medicine.repository.TagRepository;
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
    final MyMedicineRepository myMedicineRepository;
    final CollisionRepository collisionRepository;
    final TagRepository tagRepository;
    final MyMedicineHasTagRepository myMedicineHasTagRepository;

    @Override
    public Boolean regist(List<RegistRequestDto> requestDto, Profile profile) {
        List<Tag> tagList = tagRepository.findByProfileSeq(profile.getProfileSeq());
        LocalDate now = LocalDate.now();
        for(RegistRequestDto registRequestDto: requestDto){
            boolean finish = false;
            LocalDate start_date = LocalDate.parse(registRequestDto.getStart_date(),DateTimeFormatter.ISO_DATE);
            LocalDate end_date = LocalDate.parse(registRequestDto.getEnd_date(),DateTimeFormatter.ISO_DATE);
            if(end_date.isBefore(now) || start_date.isAfter(now)){// 지금 복용 안하는 약을 등록한 경우
                finish = true;
            }

            Medicine medicine = medicineRepository.findByItemSeq(registRequestDto.getItem_seq());
            MyMedicine myMedicine = MyMedicine.builder()
                .endDate(end_date)
                .finish(finish? "Y":"N")
                .medicine(medicine)
                .profile(profile)
                .startDate(start_date)
                .build();
            myMedicineRepository.save(myMedicine);
            loop:
            for(String str: registRequestDto.getTag_list()){
                for(Tag tag : tagList) {
                    if(tag.getName().equals(str)){
                        MyMedicineHasTag myMedicineHasTag = MyMedicineHasTag.builder()
                            .myMedicine(myMedicine)
                            .tag(tag)
                            .build();
                        myMedicineHasTagRepository.save(myMedicineHasTag);
                        continue loop;
                    }
                }
                Tag tag = Tag.builder()
                    .profileSeq(profile.getProfileSeq())
                    .name(str)
                    .build();
                tagRepository.save(tag);
                MyMedicineHasTag myMedicineHasTag = MyMedicineHasTag.builder()
                    .myMedicine(myMedicine)
                    .tag(tag)
                    .build();
                myMedicineHasTagRepository.save(myMedicineHasTag);
            }
        }
        return true;
    }

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
            // List<MyMedicine> myMedicineList = myMedicineRepository.findAllByDelYnAndFinishAndProfile("N","N",profile);
            // for(MyMedicine myMedicine: myMedicineList){
            //     String my_edi = myMedicine.getMedicine().getEdiCode().substring(0,9);
            //     if(collisionRepository.existsByMaterialAIdandMaterialBId())
            // }
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
    public List<MedicineTakingDto> searchTakingMedicine(Profile profile) {
        List<MedicineTakingDto> medicineTakingDtos = new ArrayList<>();
        List<MyMedicine> myMedicineList = myMedicineRepository.findAllByDelYnAndFinishAndProfile("N","N",profile);
        boolean pregnant = profile.isPregnancy();
        LocalDate birthdate = profile.getBirthDate();
        LocalDate now = LocalDate.now();
        Period period = Period.between(birthdate, now);
        int age = period.getYears();
        boolean young = age<18? true: false;
        boolean old = age>60? true: false;

        for(MyMedicine myMedicine: myMedicineList){
            boolean pregnant_warn = false;
            boolean young_warn = false;
            boolean old_warn = false;
            boolean collide = false;
            period = Period.between(myMedicine.getStartDate(),now);
            int dDay = period.getDays();
            List collide_list = new ArrayList<String>();
            Medicine medicine = myMedicine.getMedicine();
            List<MyMedicineHasTag> myMedicineHasTagList = myMedicineHasTagRepository.findByMyMedicine(myMedicine);
            List<String> tagList = new ArrayList<>();
            for(MyMedicineHasTag myMedicineHasTag: myMedicineHasTagList){
                tagList.add(myMedicineHasTag.getTag().getName());
            }

            if(pregnant && medicine.getTypeCode().contains("임")){
                pregnant_warn=true;
            }
            if(young && medicine.getTypeCode().contains("연령")){
                young_warn=true;
            }
            if(old && medicine.getTypeCode().contains("노인")){
                old_warn=true;
            }
            // collide 만들어
            medicineTakingDtos.add(MedicineTakingDto.builder()
                .itemSeq(medicine.getItemSeq())
                .img(medicine.getImg())
                .itemName(medicine.getItemName())
                .warn_age(young_warn)
                .warn_old(old_warn)
                .warn_pregnant(pregnant_warn)
                .dDay(dDay)
                .tag_list(tagList)
                .type_code(medicine.getTypeCode())
                .collide(collide)
                .collide_list(collide_list)
                .build());
        }
        return medicineTakingDtos;
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
