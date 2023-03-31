package com.ai4ai.ycc.domain.medicine.dto;


import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class TagDto {

    private long tagSeq;
    private String name;
    private int color;


}
