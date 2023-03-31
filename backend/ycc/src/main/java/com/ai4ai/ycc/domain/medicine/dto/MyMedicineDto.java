package com.ai4ai.ycc.domain.medicine.dto;

import java.util.List;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class MyMedicineDto {

    private long myMedicineSeq;
    private long itemSeq;
    private String itemName;
    private String img;
    private String typeCode;
    private List tagList;
    private int dDay;
    private boolean warnPregnant;
    private boolean warnOld;
    private boolean warnAge;

}
