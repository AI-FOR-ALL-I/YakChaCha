package com.ai4ai.ycc.domain.reminder.dto.response;

import lombok.Builder;
import lombok.Getter;

import java.util.ArrayList;
import java.util.List;

@Getter
public class ReminderDetailResponseDto {

    @Getter
    @Builder
    public static class Medicine {
        private long medicineSeq;
        private String img;
        private String name;
        private int count;
    }

    private String title;
    private String time;
    private int totalCount;
    private int typeCount;
    private List<Medicine> medicineList;

    @Builder
    public ReminderDetailResponseDto(String title, String time) {
        this.title = title;
        this.time = time;
        this.totalCount = 0;
        this.typeCount = 0;
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
        this.totalCount += count;
        this.typeCount++;
    }

}
