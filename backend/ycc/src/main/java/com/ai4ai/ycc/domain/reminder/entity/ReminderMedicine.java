package com.ai4ai.ycc.domain.reminder.entity;

import com.ai4ai.ycc.common.entity.BaseEntity;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.*;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@ToString
@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
public class ReminderMedicine extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long reminderMedicineSeq;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reminder_seq")
    private Reminder reminder;

    // ITEM_SEQ
    @Column(nullable = false)
    private long medicineSeq;

    @Column(nullable = false)
    private int count;

    @Builder
    public ReminderMedicine(Reminder reminder, long medicineSeq, int count) {
        this.reminder = reminder;
        this.medicineSeq = medicineSeq;
        this.count = count;
    }
}
