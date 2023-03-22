package com.ai4ai.ycc.domain.medicine.dto;

import lombok.Builder;

@Builder
public class MedicineDetailDto {

    private Long id;
    private Long itemSeq;
    private String itemName;
    private String entpName;
    private String itemPermitDate;
    private String etcOtcCode;
    private String chart;
    private String classNo;
    private String validTerm;
    private String storageMethod;
    private String packUnit;
    private String typeCode;
    private String changeDate;
    private String mainItemIngr;
    private String ingrName;
    private String nbDocData;
    private String udDocData;
    private String eeDocData;
    private String img;

}
