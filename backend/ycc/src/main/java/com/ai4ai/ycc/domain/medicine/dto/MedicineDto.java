package com.ai4ai.ycc.domain.medicine.dto;

import java.util.List;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class MedicineDto {

    private Long itemSeq;
    private String itemName;
    private String img;
    private String typeCode;
    private boolean collide;
    private boolean warnPregnant;
    private boolean warnOld;
    private boolean warnAge;
    private List collideList;

}
