package com.ai4ai.ycc.domain.reminder.dto.request;

import lombok.Getter;

import java.util.List;

@Getter
public class ModifyReminderRequestDto {

    private long reminderSeq;
    private long profileLinkSeq;
    private String title;
    private String time;
    private List<MedicineCountDto> medicineList;

}
