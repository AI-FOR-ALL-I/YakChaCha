package com.ai4ai.ycc.domain.medicine.dto;

import java.util.List;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class MedicineDetailDto {

    private Long medicineSeq;
    private Long itemSeq;
    private String itemName;
    private String entpName;
    private String itemPermitDate;
    private String etcOtcCode;
    private String chart;
    private String classNo;
    private boolean collide;
    private String validTerm;
    private String storageMethod;
    private String packUnit;
    private String typeCode;
    private String changeDate;
    private String mainItemIngr;
    private String ingrName;
    private String img;
    private String nbDocData;
    private String udDocData;
    private String eeDocData;
    private String materialName;
    private boolean isMine;
    private boolean warnPregnant;
    private boolean warnOld;
    private boolean warnAge;
    private List<String> startDate;
    private List<String> endDate;
    private List<String> collideList;
    private List<List<String>> tagList;
}
