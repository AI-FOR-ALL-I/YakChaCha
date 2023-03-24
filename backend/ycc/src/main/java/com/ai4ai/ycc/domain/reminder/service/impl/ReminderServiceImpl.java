package com.ai4ai.ycc.domain.reminder.service.impl;

import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.reminder.dto.request.CreateReminderRequestDto;
import com.ai4ai.ycc.domain.reminder.dto.request.MedicineCountDto;
import com.ai4ai.ycc.domain.reminder.dto.response.ReminderResponseDto;
import com.ai4ai.ycc.domain.reminder.entity.Reminder;
import com.ai4ai.ycc.domain.reminder.entity.ReminderMedicine;
import com.ai4ai.ycc.domain.reminder.repository.ReminderMedicineRepository;
import com.ai4ai.ycc.domain.reminder.repository.ReminderRepository;
import com.ai4ai.ycc.domain.reminder.service.ReminderService;
import com.ai4ai.ycc.util.DateUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;

@Transactional
@Service
@RequiredArgsConstructor
@Slf4j
public class ReminderServiceImpl implements ReminderService {

    private final DateUtil dateUtil;
    private final ReminderRepository reminderRepository;
    private final ReminderMedicineRepository reminderMedicineRepository;

    @Override
    public void createReminder(Account account, Profile profile, CreateReminderRequestDto requestDto) {
        log.info("[createReminder] 리마인더 생성 시작");

        String title = requestDto.getTitle();
        String time = requestDto.getTime();
        List<MedicineCountDto> medicineList = requestDto.getMedicineList();

        Reminder reminder = Reminder.builder()
                .profile(profile)
                .title(title)
                .time(time)
                .taken(false)
                .build();
        reminderRepository.save(reminder);

        medicineList.forEach((m) -> {
            log.info("[createReminder] 리마인더 등록 약: {}", m);
            ReminderMedicine reminderMedicine = ReminderMedicine.builder()
                    .reminder(reminder)
                    .medicineSeq(m.getMedicineSeq())
                    .count(m.getCount())
                    .build();
            reminderMedicineRepository.save(reminderMedicine);
        });

        log.info("[createReminder] 리마인더 생성 완료");
    }

    @Override
    public List<ReminderResponseDto> getReminderList(Account account) {
        return null;
    }
}
