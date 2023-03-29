package com.ai4ai.ycc.domain.medicine.dto;

import java.util.List;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class RegistRequestDto {

    private Long itemSeq;
    private String startDate;
    private String endDate;
    private String typeCode;
    private List<List<String>> tagList;

}
