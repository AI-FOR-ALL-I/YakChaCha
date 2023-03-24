package com.ai4ai.ycc.domain.reminder.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ReminderResponseDto {

    private String title;
    private String time;
    private boolean taken;

    // 1: 지남 + 안먹음
    // 2: 지남 + 먹음
    // 3: 곧
    // 4: 남은거
    private int status;

}
