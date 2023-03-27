package com.ai4ai.ycc.domain.reminder.service.impl;

import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.reminder.dto.request.CreateReminderRequestDto;
import com.ai4ai.ycc.domain.reminder.dto.request.MedicineCountDto;
import com.ai4ai.ycc.domain.reminder.dto.response.ReminderDetailResponseDto;
import com.ai4ai.ycc.domain.reminder.dto.response.ReminderResponseDto;
import com.ai4ai.ycc.domain.reminder.entity.Reminder;
import com.ai4ai.ycc.domain.reminder.entity.ReminderMedicine;
import com.ai4ai.ycc.domain.reminder.entity.TakenRecord;
import com.ai4ai.ycc.domain.reminder.repository.ReminderMedicineRepository;
import com.ai4ai.ycc.domain.reminder.repository.ReminderRepository;
import com.ai4ai.ycc.domain.reminder.repository.TakenRecordRepository;
import com.ai4ai.ycc.domain.reminder.service.ReminderService;
import com.ai4ai.ycc.error.code.ReminderErrorCode;
import com.ai4ai.ycc.error.exception.ErrorException;
import com.ai4ai.ycc.util.DateUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.bytebuddy.asm.Advice;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;

@Transactional
@Service
@RequiredArgsConstructor
@Slf4j
public class ReminderServiceImpl implements ReminderService {

    private final DateUtil dateUtil;
    private final ReminderRepository reminderRepository;
    private final ReminderMedicineRepository reminderMedicineRepository;
    private final TakenRecordRepository takenRecordRepository;

    @Override
    public void createReminder(Profile profile, CreateReminderRequestDto requestDto) {
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
    public List<ReminderResponseDto> getReminderList(Profile profile) {
        log.info("[getReminderList] 리마인더 목록 조회 시작");
        List<Reminder> reminderList = reminderRepository.findAllByProfileAndDelYn(profile, "N");

        log.info("[getReminderList] 리마인더 목록 정렬 시작");
        Collections.sort(reminderList, new Comparator<Reminder>() {
            @Override
            public int compare(Reminder o1, Reminder o2) {
                log.info("{}, {}", o1.getTime(), o2.getTime());
                LocalTime t1 = dateUtil.convertToTimeFormat(o1.getTime());
                LocalTime t2 = dateUtil.convertToTimeFormat(o2.getTime());
                log.info("{}, {}", t1, t2);
                return t1.compareTo(t2);
            }
        });
        log.info("[getReminderList] 리마인더 목록 정렬 완료");

        LocalTime now = LocalTime.now();

        List<ReminderResponseDto> resultList = new ArrayList<>();
        boolean isBefore = true;

        int status = -1;

        boolean found = false;

        for (Reminder reminder : reminderList) {
            log.info(reminder.getTime());
            LocalTime time = dateUtil.convertToTimeFormat(reminder.getTime());
            log.info("{}", time);
            if (found) {
                status = 4;
            } else if (reminder.isTaken()) {
                status = 2;
            } else if (time.isBefore(now)) {
                status = 1;
            } else if (time.isBefore(now.plusHours(1))) {
                status = 3;
                found = true;
            } else {
                status = 4;
            }

            resultList.add(ReminderResponseDto.builder()
                            .reminderSeq(reminder.getReminderSeq())
                            .title(reminder.getTitle())
                            .time(reminder.getTime())
                            .taken(reminder.isTaken())
                            .status(status)
                    .build());
        };

        log.info("[getReminderList] 리마인더 목록 조회 완료");
        return resultList;
    }

    @Override
    public ReminderDetailResponseDto getReminderDetail(Profile profile, long reminderSeq) {
        Reminder reminder = reminderRepository.findByReminderSeqAndProfileAndDelYn(reminderSeq, profile, "N")
                .orElseThrow(() -> new ErrorException(ReminderErrorCode.REMINDER_ERROR_CODE));

        ReminderDetailResponseDto result = ReminderDetailResponseDto.builder()
                .title(reminder.getTitle())
                .time(reminder.getTime())
                .build();

        List<ReminderMedicine> reminderMedicineList = reminderMedicineRepository.findAllByReminder(reminder);

        for (ReminderMedicine reminderMedicine : reminderMedicineList) {
            long medicineSeq = reminderMedicine.getMedicineSeq();
            String img = "";
            String name = "";
            int count = reminderMedicine.getCount();

            result.addMedicine(medicineSeq, img, name, count);
        }

        return result;
    }

    @Override
    public void takeMedicine(Profile profile, long reminderSeq) {
        Reminder reminder = reminderRepository.findByReminderSeqAndProfileAndDelYn(reminderSeq, profile, "N")
                .orElseThrow(() -> new ErrorException(ReminderErrorCode.REMINDER_ERROR_CODE));

        reminder.take();

        TakenRecord record = TakenRecord.builder()
                .reminder(reminder)
                .date(LocalDate.now())
                .build();

        takenRecordRepository.save(record);

    }
}
