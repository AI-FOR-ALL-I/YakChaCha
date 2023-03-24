package com.ai4ai.ycc.domain.reminder.service;

import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.reminder.dto.request.CreateReminderRequestDto;
import com.ai4ai.ycc.domain.reminder.dto.response.ReminderResponseDto;

import java.util.List;

public interface ReminderService {
    void createReminder(Account account, Profile profile, CreateReminderRequestDto requestDto);
    List<ReminderResponseDto> getReminderList(Account account);

}
