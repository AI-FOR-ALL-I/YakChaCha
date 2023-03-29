package com.ai4ai.ycc.domain.medicine.dto;

import java.util.List;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class MyMedicineDto {

    private Long itemSeq;
    private String itemName;
    private String img;
    private String type_code;
    private List tag_list;
    private int dDay;
    private boolean warn_pregnant;
    private boolean warn_old;
    private boolean warn_age;

}
