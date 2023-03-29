package com.ai4ai.ycc.domain.reminder.service;

import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.reminder.dto.request.CreateReminderRequestDto;
import com.ai4ai.ycc.domain.reminder.dto.request.ModifyReminderRequestDto;
import com.ai4ai.ycc.domain.reminder.dto.response.ReminderDetailResponseDto;
import com.ai4ai.ycc.domain.reminder.dto.response.NextReminderResponseDto;
import com.ai4ai.ycc.domain.reminder.dto.response.ReminderResponseDto;

import java.util.List;

public interface ReminderService {
    void createReminder(Profile profile, CreateReminderRequestDto requestDto);
    List<ReminderResponseDto> getReminderList(Profile profile);

    ReminderDetailResponseDto getReminderDetail(Profile profile, long reminderSeq);

    void takeMedicine(Profile profile, long reminderSeq);

    List<Integer> getTakenRecords(Profile profile, long reminderSeq, String month);

    void modifyReminder(Profile profile, long reminderSeq, ModifyReminderRequestDto requestDto);

    void removeReminder(Profile profile, long reminderSeq);

    NextReminderResponseDto getNextReminder(Profile profile);

    void resetReminder();
}
