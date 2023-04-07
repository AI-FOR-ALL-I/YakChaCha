package com.ai4ai.ycc.domain.reminder.dto.request;

import lombok.Getter;

import java.util.List;

@Getter
public class CreateReminderRequestDto {

    private String title;
    private String time;

    private List<MedicineCountDto> medicineList;

}
