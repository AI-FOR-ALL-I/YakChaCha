package com.ai4ai.ycc.domain.reminder.dto.request;

import lombok.Getter;
import lombok.ToString;

import java.util.List;

@Getter
public class CreateReminderRequestDto {

    private long profileSeq;
    private String title;
    private String time;

    private List<MedicineCountDto> medicineList;

}
