package com.ai4ai.ycc.domain.reminder.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ReminderResponseDto {

    private String title;
    private String time;
    private boolean taken;

    // 1: 지남 + 안먹음 > 빨강
    // 2: 지남 + 먹음 OR 안지남 + 먹음 > 초록
    // 3: 곧 먹을거 (현재시간 기준 1시간 이내) > 하이라이트
    // 4: 나머지 > disable
    private int status;

}
