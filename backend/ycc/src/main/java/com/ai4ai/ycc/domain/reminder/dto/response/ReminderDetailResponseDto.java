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
        private List<Tag> tags;
        private int count;
    }

    @Getter
    @Builder
    public static class Tag {
        private String name;
        private int color;
    }

    private long reminderSeq;
    private String title;
    private String time;
    private int totalCount;
    private int typeCount;
    private List<Medicine> medicineList;

    @Builder
    public ReminderDetailResponseDto(long reminderSeq, String title, String time) {
        this.reminderSeq = reminderSeq;
        this.title = title;
        this.time = time;
        this.totalCount = 0;
        this.typeCount = 0;
        this.medicineList = new ArrayList<>();
    }

    public void addMedicine(long medicineSeq, String img, String name, List<Tag> tags, int count) {
        Medicine medicine = Medicine.builder()
                .medicineSeq(medicineSeq)
                .img(img)
                .name(name)
                .tags(tags)
                .count(count)
                .build();

        this.medicineList.add(medicine);
        this.totalCount += count;
        this.typeCount++;
    }

}
