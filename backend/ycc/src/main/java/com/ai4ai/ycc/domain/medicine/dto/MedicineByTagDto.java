package com.ai4ai.ycc.domain.medicine.dto;

import java.util.List;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class MedicineByTagDto {

    private Long itemSeq;
    private String itemName;
    private String img;
    private List<List<String>> tagList;

}
