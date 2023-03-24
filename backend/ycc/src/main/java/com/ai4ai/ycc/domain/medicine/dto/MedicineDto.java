package com.ai4ai.ycc.domain.medicine.dto;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class MedicineDto {

    private Long medicineSeq;
    private Long itemSeq;
    private String itemName;
    private String img;

}
