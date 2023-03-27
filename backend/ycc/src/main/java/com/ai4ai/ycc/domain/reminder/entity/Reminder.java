package com.ai4ai.ycc.domain.reminder.entity;

import com.ai4ai.ycc.common.entity.BaseEntity;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.*;

import javax.persistence.*;
import java.time.LocalTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED) // 아무런 값도 갖지않는 의미 없는 객체의 생성을 막음.
@ToString(exclude = "refreshToken")
@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
public class Reminder extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long reminderSeq;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "profile_seq", nullable = false)
    private Profile profile;
    private String title;
    private String time;
    private boolean taken;

    @Builder
    public Reminder(Profile profile, String title, String time, boolean taken) {
        this.profile = profile;
        this.title = title;
        this.time = time;
        this.taken = taken;
    }

    public void take() {
        this.taken = true;
    }


}
