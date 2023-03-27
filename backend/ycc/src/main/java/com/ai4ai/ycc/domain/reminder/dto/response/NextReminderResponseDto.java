package com.ai4ai.ycc.domain.reminder.dto.response;

import com.ai4ai.ycc.domain.reminder.dto.request.MedicineCountDto;
import lombok.Builder;
import lombok.Getter;

import java.util.ArrayList;
import java.util.List;

@Getter
public class NextReminderResponseDto {

    @Getter
    @Builder
    public static class Medicine {
        private long medicineSeq;
        private String img;
        private String name;
        private int count;
    }

    private long reminderSeq;
    private String title;
    private String time;
    private List<Medicine> medicineList;

    @Builder
    public NextReminderResponseDto(long reminderSeq, String title, String time) {
        this.reminderSeq = reminderSeq;
        this.title = title;
        this.time = time;
        this.medicineList = new ArrayList<>();
    }

    public void addMedicine(long medicineSeq, String img, String name, int count) {
        Medicine medicine = Medicine.builder()
                .medicineSeq(medicineSeq)
                .img(img)
                .name(name)
                .count(count)
                .build();

        this.medicineList.add(medicine);
    }


}
