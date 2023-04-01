package com.ai4ai.ycc.domain.medicine.service.impl;

import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ai4ai.ycc.domain.medicine.dto.MedicineByTagDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDetailDto;
import com.ai4ai.ycc.domain.medicine.dto.MedicineDto;
import com.ai4ai.ycc.domain.medicine.dto.MyMedicineDto;
import com.ai4ai.ycc.domain.medicine.dto.RegistRequestDto;
import com.ai4ai.ycc.domain.medicine.dto.TagDto;
import com.ai4ai.ycc.domain.medicine.entity.Collision;
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
@Transactional
@RequiredArgsConstructor
@Slf4j
public class MedicineServiceImpl implements MedicineService {
    final MedicineRepository medicineRepository;
    final MedicineDetailRepository medicineDetailRepository;
    final MyMedicineRepository myMedicineRepository;
    final CollisionRepository collisionRepository;
    final TagRepository tagRepository;
    final MyMedicineHasTagRepository myMedicineHasTagRepository;


    // 내 약 등록
    @Override
    public void regist(List<RegistRequestDto> requestDto, Profile profile) {
        List<Tag> tagList = tagRepository.findAllByProfileSeqAndDelYn(profile.getProfileSeq(),"N");
        LocalDate now = LocalDate.now();
        for(RegistRequestDto registRequestDto: requestDto){
            boolean finish = false;
            System.out.println(registRequestDto.getEndDate());
            LocalDate startDate = LocalDate.parse(registRequestDto.getStartDate(),DateTimeFormatter.ISO_DATE);
            LocalDate endDate = LocalDate.parse(registRequestDto.getEndDate(),DateTimeFormatter.ISO_DATE);
            if(endDate.isBefore(now) || startDate.isAfter(now)){// 지금 복용 안하는 약을 등록한 경우
                finish = true;
            }

            Medicine medicine = medicineRepository.findByItemSeq(registRequestDto.getItemSeq());
            List<MyMedicine> myMedicineList = myMedicineRepository.findAllByDelYnAndFinishAndProfile("N","N",profile);

            for(MyMedicine temp_Medicine: myMedicineList){
                if(temp_Medicine.getMedicine()==medicine){
                    deleteMyMedicine(profile, temp_Medicine.getMyMedicineSeq());
                    break;
                }
            }
            MyMedicine myMedicine = MyMedicine.builder()
                .endDate(endDate)
                .finish(finish? "Y":"N")
                .medicine(medicine)
                .profile(profile)
                .startDate(startDate)
                .build();
            myMedicineRepository.save(myMedicine);
            loop:
            for(List<String> tag: registRequestDto.getTagList()){
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
        return;
    }

    @Override
    public List<MedicineDto> searchMedicine(List<String> input, Profile profile, String type) {
        List<MedicineDto> medicineDtoList = new ArrayList<>();
        List<Medicine> medicineList = new ArrayList<>();
        switch(type){
            case "text":
                medicineList = medicineRepository.findAllByItemNameLike("%"+input.get(0)+"%");
                break;
            case "paper":
                for(String tempInput: input){
                    List<Medicine> tempArrayList = new ArrayList<>();
                    tempArrayList = medicineRepository.findAllByEdiCodeLike("%"+tempInput+"%");
                    for(Medicine medicine: tempArrayList){
                        medicineList.add(medicine);
                    }
                }
                break;
            case "img":
                List<Long> tempList = new ArrayList<>();
                for(String medicine: input){
                    tempList.add(Long.parseLong(medicine));
                }
                medicineList = medicineRepository.findAllByItemSeqIn(tempList);
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
        List<Integer> myMedicineForCollide = new ArrayList<>();
        for(MyMedicine myMedicine: myMedicineList){
            String edi = myMedicine.getMedicine().getEdiCode();
            if(edi.length()>8){
                myMedicineForCollide.add(Integer.parseInt(edi.substring(0,9)));
            }
        }
        List<Collision> collisionPossibleList = collisionRepository.findAllByMedicineAIdIn(myMedicineForCollide);

        for(Medicine medicine: medicineList){
            boolean pregnantWarn = false;
            boolean youngWarn = false;
            boolean oldWarn = false;
            boolean collide = false;
            List collideList = new ArrayList<String>();
            
            if(pregnant && medicine.getTypeCode().contains("임")){
                pregnantWarn=true;
            }
            if(young && medicine.getTypeCode().contains("연령")){
                youngWarn=true;
            }
            if(old && medicine.getTypeCode().contains("노인")){
                oldWarn=true;
            }
            String edi = medicine.getEdiCode();
            if(edi.length()>8){
                for(MyMedicine myMedicine: myMedicineList){
                    String myEdi = myMedicine.getMedicine().getEdiCode();
                    if(myEdi.length()>8){
                        for(Collision collision: collisionPossibleList){
                            if(collision.getMedicineAId()==Integer.parseInt(myEdi.substring(0,9))&&collision.getMedicineBId()==Integer.parseInt(edi.substring(0,9))){
                                collide=true;
                                collideList.add(myMedicine.getMedicine().getItemName());
                            }
                        }
                    }
                }
            }

            medicineDtoList.add(MedicineDto.builder()
                    .itemSeq(medicine.getItemSeq())
                    .img(medicine.getImg())
                    .itemName(medicine.getItemName())
                    .collide(collide)
                    .collideList(collideList)
                    .warnAge(youngWarn)
                    .warnOld(oldWarn)
                    .warnPregnant(pregnantWarn)
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
            boolean pregnantWarn = false;
            boolean youngWarn = false;
            boolean oldWarn = false;
            long dDay = ChronoUnit.DAYS.between(now, myMedicine.getEndDate());

            Medicine medicine = myMedicine.getMedicine();
            List<MyMedicineHasTag> myMedicineHasTagList = myMedicineHasTagRepository.findByMyMedicineAndDelYn(myMedicine,"N");
            List<List> tagList = new ArrayList<>();
            for(MyMedicineHasTag myMedicineHasTag: myMedicineHasTagList){
                List<String> tag = new ArrayList<>();
                tag.add(myMedicineHasTag.getTag().getName());
                tag.add(Long.toString(myMedicineHasTag.getTag().getColor()));
                tagList.add(tag);
            }

            if(pregnant && medicine.getTypeCode().contains("임")){
                pregnantWarn=true;
            }
            if(young && medicine.getTypeCode().contains("연령")){
                youngWarn=true;
            }
            if(old && medicine.getTypeCode().contains("노인")){
                oldWarn=true;
            }

            myMedicineDtos.add(MyMedicineDto.builder()
                .myMedicineSeq(myMedicine.getMyMedicineSeq())
                .itemSeq(medicine.getItemSeq())
                .img(medicine.getImg())
                .itemName(medicine.getItemName())
                .warnAge(youngWarn)
                .warnOld(oldWarn)
                .warnPregnant(pregnantWarn)
                .dDay((int)dDay)
                .tagList(tagList)
                .typeCode(medicine.getTypeCode())
                .build());
        }
        return myMedicineDtos;
    }

    @Override
    public List<TagDto> showTags(Profile profile) {
        List<Tag> tags = tagRepository.findAllByProfileSeqAndDelYn(profile.getProfileSeq(),"N");
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
    public List<MedicineByTagDto> searchByTags(Profile profile, List<String> tagList) {
        List<MyMedicineHasTag> myMedicineHasTagList=myMedicineHasTagRepository.findAllByDelYnAndTag_NameIn(tagList,
            profile.getProfileSeq());
        HashMap<MyMedicine, List<List<String>>> myMedicineListHashMap = new HashMap<>();
        for(MyMedicineHasTag myMedicineHasTag : myMedicineHasTagList){
            MyMedicine myMedicine =myMedicineHasTag.getMyMedicine();
            if(myMedicineListHashMap.containsKey(myMedicine)) {
                continue;
            }
            List<MyMedicineHasTag> tempMyMedicineHasTags = myMedicineHasTagRepository.findAllByDelYnAndMyMedicine("N",myMedicine);
            List<List<String>> tags = new ArrayList<>();
            for(MyMedicineHasTag tempMyMedicineHasTag: tempMyMedicineHasTags){
                List<String> tag = new ArrayList<>();
                tag.add(tempMyMedicineHasTag.getTag().getName());
                tag.add(Integer.toString(tempMyMedicineHasTag.getTag().getColor()));
                tags.add(tag);
            }

            myMedicineListHashMap.put(myMedicine,tags);
        }
        List<MedicineByTagDto> output = new ArrayList<>();
        for(MyMedicine myMedicine : myMedicineListHashMap.keySet()){
            output.add(MedicineByTagDto.builder()
                    .tagList(myMedicineListHashMap.get(myMedicine))
                    .img(myMedicine.getMedicine().getImg())
                    .itemName(myMedicine.getMedicine().getItemName())
                    .itemSeq(myMedicine.getMedicine().getItemSeq())
                .build());
        }

        return output;
    }

    @Override
    public void deleteTags(Profile profile, String tagName) {
        MyMedicineHasTag myMedicineHasTag= myMedicineHasTagRepository.findByTag_NameAndDelYnAndTag_ProfileSeq(tagName,"N",profile.getProfileSeq());
        myMedicineHasTag.setDelYn("Y");
        Tag tag = myMedicineHasTag.getTag();
        tag.setDelYn("Y");
        tagRepository.save(myMedicineHasTag.getTag());
        myMedicineHasTagRepository.save(myMedicineHasTag);

    }

    @Override
    public void deleteMyMedicine(Profile profile, long myMedicineSeq) {
        MyMedicine myMedicine = myMedicineRepository.findByMyMedicineSeq(myMedicineSeq);
        List<MyMedicineHasTag> myMedicineHasTags = myMedicineHasTagRepository.findByMyMedicineAndDelYn(myMedicine,"N");
        for (MyMedicineHasTag myMedicineHasTag : myMedicineHasTags){
            myMedicineHasTag.remove();
        }
        myMedicine.remove();
    }

    @Override
    public MedicineDetailDto showDetail(long itemSeq, Profile profile) {
        System.out.println(itemSeq+"의 itemSeq를 가진 약 검색");
        Medicine medicine = medicineRepository.findByItemSeq(itemSeq);

        boolean pregnant = profile.isPregnancy();
        LocalDate birthdate = profile.getBirthDate();
        LocalDate now = LocalDate.now();
        Period period = Period.between(birthdate, now);
        int age = period.getYears();
        boolean young = age<18? true: false;
        boolean old = age>60? true: false;

        List<MyMedicine> myMedicineList = myMedicineRepository.findAllByDelYnAndProfile("N",profile);

        boolean collide = false;
        boolean isMine = false;
        boolean pregnantWarn = false;
        boolean youngWarn = false;
        boolean oldWarn = false;
        if(pregnant && medicine.getTypeCode().contains("임")){
            pregnantWarn=true;
        }
        if(young && medicine.getTypeCode().contains("연령")){
            youngWarn=true;
        }
        if(old && medicine.getTypeCode().contains("노인")){
            oldWarn=true;
        }
        List<String> collideList = new ArrayList<>();
        List<String> startDate=new ArrayList<>();
        List<String> endDate=new ArrayList<>();
        List<List<String>> tagList = new ArrayList<>();
        for(MyMedicine myMedicine: myMedicineList){
            String myEdi = myMedicine.getMedicine().getEdiCode();
            String edi = medicine.getEdiCode();
            if(myMedicine.getMedicine().getItemSeq()== itemSeq){
                isMine=true;
                startDate.add(myMedicine.getStartDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
                endDate.add(myMedicine.getEndDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
                List<MyMedicineHasTag> myMedicineHasTagList = myMedicineHasTagRepository.findByMyMedicineAndDelYn(myMedicine,"N");

                for(MyMedicineHasTag myMedicineHasTag: myMedicineHasTagList){
                    List<String> tag = new ArrayList<>();
                    tag.add(myMedicineHasTag.getTag().getName());
                    tag.add(Long.toString(myMedicineHasTag.getTag().getColor()));
                    tagList.add(tag);
                }
            }
            if(myEdi.length()>8&&edi.length()>8&&collisionRepository.existsByMedicineAIdAndMedicineBId(Integer.parseInt(myEdi.substring(0,9)),Integer.parseInt(edi.substring(0,9)))){
                System.out.println("충돌!");
                collide=true;
                collideList.add(myMedicine.getMedicine().getItemName());
            }
        }
        Collections.sort(startDate, new Comparator<String>() {
            @Override
            public int compare(String o1, String o2) {
                for(int i=0; i<10;i++){
                    if(o1.charAt(i)!=o2.charAt(i)){
                        return o1.charAt(i)-o2.charAt(i);
                    }
                }
                return 0;
            }
        });
        Collections.sort(endDate, new Comparator<String>() {
            @Override
            public int compare(String o1, String o2) {
                for(int i=0; i<10;i++){
                    if(o1.charAt(i)!=o2.charAt(i)){
                        return o1.charAt(i)-o2.charAt(i);
                    }
                }
                return 0;
            }
        });
        MedicineDetailDto medicineDetailDto=MedicineDetailDto.builder()
            .chart(medicine.getDetail().getChart())
            .etcOtcCode(medicine.getDetail().getEtcOtcCode())
            .entpName(medicine.getDetail().getEntpName())
            .changeDate(medicine.getDetail().getChangeDate())
            .medicineSeq(medicine.getMedicineSeq())
            .ingrName(medicine.getDetail().getIngrName())
            .itemPermitDate(medicine.getDetail().getItemPermitDate())
            .classNo(medicine.getDetail().getClassNo())
            .mainItemIngr(medicine.getDetail().getMainItemIngr())
            .packUnit(medicine.getDetail().getPackUnit())
            .storageMethod(medicine.getDetail().getStorageMethod())
            .typeCode(medicine.getTypeCode())
            .validTerm(medicine.getDetail().getValidTerm())
            .itemSeq(itemSeq)
            .itemName(medicine.getItemName())
            .img(medicine.getImg())
            .collide(collide)
            .collideList(collideList)
            .udDocData(medicine.getDetail().getUdDocData())
            .nbDocData(medicine.getDetail().getNbDocData())
            .eeDocData(medicine.getDetail().getEeDocData())
            .materialName(medicine.getDetail().getMaterialName())
            .isMine(isMine)
            .startDate(startDate)
            .endDate(endDate)
            .warnOld(oldWarn)
            .warnAge(youngWarn)
            .warnPregnant(pregnantWarn)
            .tagList(tagList)
            .build();

        return medicineDetailDto;
    }
}
