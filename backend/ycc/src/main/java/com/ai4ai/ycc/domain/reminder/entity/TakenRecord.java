package com.ai4ai.ycc.domain.reminder.entity;

import com.ai4ai.ycc.common.entity.BaseEntity;
import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.*;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@ToString(exclude = "refreshToken")
@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
public class TakenRecord extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long takenRecordSeq;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reminder_seq")
    private Reminder reminder;

    @Column(nullable = false)
    private LocalDate date;

    @Builder
    public TakenRecord(Reminder reminder, LocalDate date) {
        this.reminder = reminder;
        this.date = date;
    }

}
