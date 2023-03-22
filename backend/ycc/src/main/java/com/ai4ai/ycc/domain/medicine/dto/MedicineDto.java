package com.ai4ai.ycc.domain.medicine.dto;

import lombok.Builder;

@Builder
public class MedicineDto {

    private Long id;
    private Long itemSeq;
    private String itemName;
    private String img;

}
