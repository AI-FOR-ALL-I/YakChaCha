package com.ai4ai.ycc.domain.medicine.service.impl;

import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.ai4ai.ycc.domain.medicine.dto.MedicineDetailDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDto;
import com.ai4ai.ycc.domain.medicine.dto.MyMedicineDto;
import com.ai4ai.ycc.domain.medicine.dto.RegistRequestDto;
import com.ai4ai.ycc.domain.medicine.dto.TagDto;
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
            System.out.println(medicine==null);
            MyMedicine myMedicine = MyMedicine.builder()
                .endDate(end_date)
                .finish(finish? "Y":"N")
                .medicine(medicine)
                .profile(profile)
                .startDate(start_date)
                .build();
            myMedicineRepository.save(myMedicine);
            loop:
            for(List<String> tag: registRequestDto.getTag_list()){
                for(Tag mytag : tagList) {
                    if(mytag.getName().equals(tag.get(0))){
                        MyMedicineHasTag myMedicineHasTag = MyMedicineHasTag.builder()
                            .myMedicine(myMedicine)
                            .tag(mytag)
                            .build();
                        myMedicineHasTagRepository.save(myMedicineHasTag);
                        continue loop;
                    }
                }
                Tag mytag = Tag.builder()
                    .profileSeq(profile.getProfileSeq())
                    .name(tag.get(0))
                    .color(Integer.parseInt(tag.get(1)))
                    .build();
                tagRepository.save(mytag);
                MyMedicineHasTag myMedicineHasTag = MyMedicineHasTag.builder()
                    .myMedicine(myMedicine)
                    .tag(mytag)
                    .build();
                myMedicineHasTagRepository.save(myMedicineHasTag);
            }
        }
        return true;
    }

    @Override
    public List<MedicineDto> searchMedicine(String input, Profile profile, String type) {
        List<MedicineDto> medicineDtoList = new ArrayList<>();
        List<Medicine> medicineList = new ArrayList<>();
        switch(type){
            case "text":
                medicineList = medicineRepository.findByItemNameLike("%"+input+"%");
                break;
            case "img":
                medicineList = medicineRepository.findByEdiCodeLike("%"+input+"%");
                break;
            default:
                break;
        }
        boolean pregnant = profile.isPregnancy();
        LocalDate birthdate = profile.getBirthDate();
        LocalDate now = LocalDate.now();
        Period period = Period.between(birthdate, now);
        int age = period.getYears();
        boolean young = age<18? true: false;
        boolean old = age>60? true: false;

        List<MyMedicine> myMedicineList = myMedicineRepository.findAllByDelYnAndFinishAndProfile("N","N",profile);
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
            for(MyMedicine myMedicine: myMedicineList){
                String my_edi = myMedicine.getMedicine().getEdiCode();
                if(my_edi.length()>8&&collisionRepository.existsByMedicineAIdAndMedicineBId(Integer.parseInt(my_edi.substring(0,9)),Integer.parseInt(medicine.getEdiCode()))){
                    System.out.println("충돌!");
                    collide=true;
                    collide_list.add(myMedicine.getMedicine().getItemName());
                }
            }
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
    public List<MyMedicineDto> searchMyMedicine(Profile profile, boolean taking) {
        List<MyMedicineDto> myMedicineDtos = new ArrayList<>();
        List<MyMedicine> myMedicineList = myMedicineRepository.findAllByDelYnAndFinishAndProfile("N",taking?"N":"Y",profile);
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
            long dDay = ChronoUnit.DAYS.between(now, myMedicine.getEndDate());

            Medicine medicine = myMedicine.getMedicine();
            List<MyMedicineHasTag> myMedicineHasTagList = myMedicineHasTagRepository.findByMyMedicine(myMedicine);
            List<List> tagList = new ArrayList<>();
            for(MyMedicineHasTag myMedicineHasTag: myMedicineHasTagList){
                List<String> tag = new ArrayList<>();
                tag.add(myMedicineHasTag.getTag().getName());
                tag.add(Long.toString(myMedicineHasTag.getTag().getColor()));
                tagList.add(tag);
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

            myMedicineDtos.add(MyMedicineDto.builder()
                .itemSeq(medicine.getItemSeq())
                .img(medicine.getImg())
                .itemName(medicine.getItemName())
                .warn_age(young_warn)
                .warn_old(old_warn)
                .warn_pregnant(pregnant_warn)
                .dDay((int)dDay)
                .tag_list(tagList)
                .type_code(medicine.getTypeCode())
                .build());
        }
        return myMedicineDtos;
    }

    @Override
    public List<TagDto> showTags(Profile profile) {
        List<Tag> tags = myMedicineHasTagRepository.findByTag_ProfileSeq(profile.getProfileSeq());
        List<TagDto> output = new ArrayList<>();
        for(Tag tag: tags){
            output.add(TagDto.builder()
                    .tagSeq(tag.getTagSeq())
                    .color(tag.getColor())
                    .name(tag.getName())
                .build());
        }
        return output;
    }

    @Override
    public MedicineDetailDto showDetail(long itemSeq, Profile profile) {
        System.out.println(itemSeq+"의 itemSeq를 가진 약 검색");
        Medicine medicine = medicineRepository.findByItemSeq(itemSeq);

        List<MyMedicine> myMedicineList = myMedicineRepository.findAllByDelYnAndFinishAndProfile("N","N",profile);
        boolean collide = false;
        boolean isMine = false;
        List<String> collide_list = new ArrayList<>();
        String start_date="";
        String end_date="";
        List<List<String>> tagList = new ArrayList<>();
        for(MyMedicine myMedicine: myMedicineList){
            String my_edi = myMedicine.getMedicine().getEdiCode();
            String edi = medicine.getEdiCode();
            if(myMedicine.getMedicine().getItemSeq()== itemSeq){
                isMine=true;
                start_date= myMedicine.getStartDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                end_date= myMedicine.getEndDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                List<MyMedicineHasTag> myMedicineHasTagList = myMedicineHasTagRepository.findByMyMedicine(myMedicine);

                for(MyMedicineHasTag myMedicineHasTag: myMedicineHasTagList){
                    List<String> tag = new ArrayList<>();
                    tag.add(myMedicineHasTag.getTag().getName());
                    tag.add(Long.toString(myMedicineHasTag.getTag().getColor()));
                    tagList.add(tag);
                }
            }
            if(my_edi.length()>8&&edi.length()>8&&collisionRepository.existsByMedicineAIdAndMedicineBId(Integer.parseInt(my_edi.substring(0,9)),Integer.parseInt(edi.substring(0,9)))){
                System.out.println("충돌!");
                collide=true;
                collide_list.add(myMedicine.getMedicine().getItemName());
            }
        }
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
            .collide(collide)
            .collide_list(collide_list)
            .udDocData(medicine.getDetail().getUdDocData())
            .nbDocData(medicine.getDetail().getNbDocData())
            .eeDocData(medicine.getDetail().getEeDocData())
            .materialName(medicine.getDetail().getMaterialName())
            .isMine(isMine)
            .startDate(start_date)
            .endDate(end_date)
            .tag_list(tagList)
            .build();

        return medicineDetailDto;
    }
}
