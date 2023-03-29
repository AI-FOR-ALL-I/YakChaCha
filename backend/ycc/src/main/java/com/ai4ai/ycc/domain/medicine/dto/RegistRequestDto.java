package com.ai4ai.ycc.domain.medicine.dto;

import java.util.List;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class RegistRequestDto {

    private Long item_seq;
    private String start_date;
    private String end_date;
    private String type_code;
    private List<List<String>> tag_list;

}
