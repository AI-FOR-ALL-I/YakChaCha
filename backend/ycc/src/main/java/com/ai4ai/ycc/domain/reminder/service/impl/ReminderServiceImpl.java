package com.ai4ai.ycc.domain.reminder.service.impl;

import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.medicine.entity.Medicine;
import com.ai4ai.ycc.domain.medicine.entity.MyMedicine;
import com.ai4ai.ycc.domain.medicine.entity.MyMedicineHasTag;
import com.ai4ai.ycc.domain.medicine.entity.Tag;
import com.ai4ai.ycc.domain.medicine.repository.MedicineRepository;
import com.ai4ai.ycc.domain.medicine.repository.MyMedicineHasTagRepository;
import com.ai4ai.ycc.domain.medicine.repository.MyMedicineRepository;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.profile.entity.ProfileLink;
import com.ai4ai.ycc.domain.profile.repository.ProfileLinkRepository;
import com.ai4ai.ycc.domain.reminder.dto.request.CreateReminderRequestDto;
import com.ai4ai.ycc.domain.reminder.dto.request.MedicineCountDto;
import com.ai4ai.ycc.domain.reminder.dto.request.ModifyReminderRequestDto;
import com.ai4ai.ycc.domain.reminder.dto.response.ReminderDetailResponseDto;
import com.ai4ai.ycc.domain.reminder.dto.response.NextReminderResponseDto;
import com.ai4ai.ycc.domain.reminder.dto.response.ReminderResponseDto;
import com.ai4ai.ycc.domain.reminder.entity.Reminder;
import com.ai4ai.ycc.domain.reminder.entity.ReminderMedicine;
import com.ai4ai.ycc.domain.reminder.entity.TakenRecord;
import com.ai4ai.ycc.domain.reminder.repository.ReminderMedicineRepository;
import com.ai4ai.ycc.domain.reminder.repository.ReminderRepository;
import com.ai4ai.ycc.domain.reminder.repository.TakenRecordRepository;
import com.ai4ai.ycc.domain.reminder.service.ReminderService;
import com.ai4ai.ycc.error.code.ProfileLinkErrorCode;
import com.ai4ai.ycc.error.code.ReminderErrorCode;
import com.ai4ai.ycc.error.exception.ErrorException;
import com.ai4ai.ycc.util.DateUtil;
import com.ai4ai.ycc.util.FcmUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
    private final ProfileLinkRepository profileLinkRepository;
    private final TakenRecordRepository takenRecordRepository;
    private final MedicineRepository medicineRepository;
    private final MyMedicineRepository myMedicineRepository;
    private final MyMedicineHasTagRepository myMedicineHasTagRepository;
    private final FcmUtil fcmUtil;

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
                LocalTime t1 = dateUtil.convertToTimeFormat(o1.getTime());
                LocalTime t2 = dateUtil.convertToTimeFormat(o2.getTime());
                return t1.compareTo(t2);
            }
        });
        log.info("[getReminderList] 리마인더 목록 정렬 완료");

        LocalTime now = LocalTime.now();

        List<ReminderResponseDto> resultList = new ArrayList<>();

        int status = -1;
        boolean found = false;

        for (Reminder reminder : reminderList) {
            LocalTime time = dateUtil.convertToTimeFormat(reminder.getTime());
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
                .reminderSeq(reminderSeq)
                .title(reminder.getTitle())
                .time(reminder.getTime())
                .build();

        List<ReminderMedicine> reminderMedicineList = reminderMedicineRepository.findAllByReminderAndDelYn(reminder, "N");

        for (ReminderMedicine reminderMedicine : reminderMedicineList) {
            long medicineSeq = reminderMedicine.getMedicineSeq();
            Medicine medicine = medicineRepository.findByItemSeq(medicineSeq);

            if (medicine == null) {
                log.info("NOT FOUND MEDICINE");
                continue;
            }

            String img = medicine.getImg() == null ? "" : medicine.getImg();
            String name = medicine.getItemName();
            int count = reminderMedicine.getCount();

            List<ReminderDetailResponseDto.Tag> tags = new ArrayList<>();

            MyMedicine myMedicine = myMedicineRepository.findByProfileAndMedicineAndFinishAndDelYn(profile, medicine, "N", "N")
                    .orElse(null);

            if (myMedicine == null) {
                log.info("NOT FOUND MY MEDICINE");
                continue;
            }

            List<MyMedicineHasTag> myMedicineHasTagList = myMedicineHasTagRepository.findAllByDelYnAndMyMedicine("N", myMedicine);
            for (MyMedicineHasTag myMedicineHasTag : myMedicineHasTagList) {
                Tag tag =myMedicineHasTag.getTag();
                tags.add(ReminderDetailResponseDto.Tag.builder()
                                .name(tag.getName())
                                .color(tag.getColor())
                        .build());
            }

            result.addMedicine(medicineSeq, img, name, tags, count);
        }

        return result;
    }

    @Override
    public void takeMedicine(Profile profile, long reminderSeq) {
        Reminder reminder = reminderRepository.findByReminderSeqAndProfileAndDelYn(reminderSeq, profile, "N")
                .orElseThrow(() -> new ErrorException(ReminderErrorCode.REMINDER_ERROR_CODE));

        if (reminder.isTaken()) {
            throw new ErrorException(ReminderErrorCode.ALREADY_TAKEN);
        }

        reminder.take();

        TakenRecord record = TakenRecord.builder()
                .reminder(reminder)
                .date(LocalDate.now())
                .build();

        takenRecordRepository.save(record);

    }

    @Override
    public List<Integer> getTakenRecords(Profile profile, long reminderSeq, String month) {
        Reminder reminder = reminderRepository.findByReminderSeqAndProfileAndDelYn(reminderSeq, profile, "N")
                .orElseThrow(() -> new ErrorException(ReminderErrorCode.REMINDER_ERROR_CODE));

        LocalDate startDate = dateUtil.convertToDateFormat(month + "-01");
        LocalDate endDate = startDate.plusMonths(1).minusDays(1);
        List<TakenRecord> takenRecords = takenRecordRepository.findAllByReminderAndDelYnAndDateBetween(reminder, "N", startDate, endDate);

        List<Integer> result = new ArrayList<>();

        for (TakenRecord takenRecord : takenRecords) {
            result.add(takenRecord.getDate().getDayOfMonth());
        }

        return result;
    }

    @Override
    public void modifyReminder(Profile profile, long reminderSeq, ModifyReminderRequestDto requestDto) {
        Reminder reminder = reminderRepository.findByReminderSeqAndProfileAndDelYn(reminderSeq, profile, "N")
                .orElseThrow(() -> new ErrorException(ReminderErrorCode.REMINDER_ERROR_CODE));

        String title = requestDto.getTitle();
        String time = requestDto.getTime();

        reminder.modify(title, time);

        List<ReminderMedicine> reminderMedicineList = reminderMedicineRepository.findAllByReminderAndDelYn(reminder, "N");
        reminderMedicineList.forEach((m) -> m.remove());

        List<MedicineCountDto> medicineList = requestDto.getMedicineList();
        medicineList.forEach((m) -> {
            log.info("[createReminder] 리마인더 등록 약: {}", m);
            ReminderMedicine reminderMedicine = ReminderMedicine.builder()
                    .reminder(reminder)
                    .medicineSeq(m.getMedicineSeq())
                    .count(m.getCount())
                    .build();
            reminderMedicineRepository.save(reminderMedicine);
        });

    }

    @Override
    public void removeReminder(Profile profile, long reminderSeq) {
        log.info("[removeReminder] 리마인더 삭제 시작");
        Reminder reminder = reminderRepository.findByReminderSeqAndProfileAndDelYn(reminderSeq, profile, "N")
                .orElseThrow(() -> new ErrorException(ReminderErrorCode.REMINDER_ERROR_CODE));

        log.info("[removeReminder] 약 섭취 기록 조회");
        List<TakenRecord> recordList = takenRecordRepository.findAllByReminderAndDelYn(reminder, "N");
        recordList.forEach(r -> r.remove());
        log.info("[removeReminder] 약 섭취 기록 삭제 완료");

        log.info("[removeReminder] 리마인더 약 목록 조회");
        List<ReminderMedicine> reminderMedicineList = reminderMedicineRepository.findAllByReminderAndDelYn(reminder, "N");
        reminderMedicineList.forEach(rm -> rm.remove());
        log.info("[removeReminder] 리마인더 약 목록 삭제 완료");

        reminder.remove();
        log.info("[removeReminder] 리마인더 삭제 완료");
    }

    @Override
    public NextReminderResponseDto getNextReminder(Profile profile) {
        log.info("[getNextReminder] 곧 다가오는 리마인더 조회");
        List<Reminder> reminderList = reminderRepository.findAllByProfileAndDelYn(profile, "N");

        log.info("[getNextReminder] 리마인더 목록 정렬 시작");
        Collections.sort(reminderList, new Comparator<Reminder>() {
            @Override
            public int compare(Reminder o1, Reminder o2) {
                LocalTime t1 = dateUtil.convertToTimeFormat(o1.getTime());
                LocalTime t2 = dateUtil.convertToTimeFormat(o2.getTime());
                return t1.compareTo(t2);
            }
        });
        log.info("[getNextReminder] 리마인더 목록 정렬 완료");

        LocalTime now = LocalTime.now();

        for (Reminder reminder : reminderList) {
            LocalTime time = dateUtil.convertToTimeFormat(reminder.getTime());
            if (reminder.isTaken() || time.isBefore(now)) {
                continue;
            }

            NextReminderResponseDto result = NextReminderResponseDto.builder()
                    .reminderSeq(reminder.getReminderSeq())
                    .title(reminder.getTitle())
                    .time(reminder.getTime())
                    .build();

            List<ReminderMedicine> reminderMedicineList = reminderMedicineRepository.findAllByReminderAndDelYn(reminder, "N");

            for (ReminderMedicine reminderMedicine : reminderMedicineList) {
                long medicineSeq = reminderMedicine.getMedicineSeq();
                String img = "";
                String name = "";
                int count = reminderMedicine.getCount();

                result.addMedicine(medicineSeq, img, name, count);
            }

            return result;
        }

        return null;
    }

    @Override
    public void resetReminder() {
        log.info("[resetReminder] 리마인더 초기화 시작");
        List<Reminder> reminderList = reminderRepository.findAllByDelYn("N");
        for (Reminder reminder : reminderList) {
            reminder.reset();
        }
        log.info("[resetReminder] 리마인더 초기화 완료");
    }

    @Override
    public List<ProfileLink> getProfileLinkListAtTime(String time) {
        List<Reminder> reminderList = reminderRepository.findAllByTimeAndDelYn(time, "N");
        List<ProfileLink> result = new ArrayList<>();

        for (Reminder reminder : reminderList) {
            if (reminder.isTaken()) {
                continue;
            }
            Profile profile = reminder.getProfile();
            result.addAll(profileLinkRepository.findAllByProfileAndDelYn(profile, "N"));
        }

        return result;
    }

    @Override
    public void removeByMyMedicine(MyMedicine myMedicine) {
        Profile profile = myMedicine.getProfile();
        List<Reminder> reminderList = reminderRepository.findAllByProfileAndDelYn(profile, "N");

        for (Reminder reminder : reminderList) {
            List<ReminderMedicine> reminderMedicineList = reminderMedicineRepository.findAllByReminderAndDelYn(reminder, "N");
            int count = reminderMedicineList.size();

            for (ReminderMedicine reminderMedicine : reminderMedicineList) {
                if (reminderMedicine.getMedicineSeq() == myMedicine.getMedicine().getItemSeq()) {
                    reminderMedicine.remove();
                    count--;
                    break;
                }
            }

            if (count == 0) {
                List<TakenRecord> takenRecords = takenRecordRepository.findAllByReminderAndDelYn(reminder, "N");
                takenRecords.forEach(r -> r.remove());
                reminder.remove();
            }
        }
    }

    @Override
    public void test(Account account) {
        List<ProfileLink> profileLinkList = profileLinkRepository.findAllByAccountAndDelYn(account, "N");
        if (profileLinkList.isEmpty()) {
            throw new ErrorException(ProfileLinkErrorCode.NOT_FOUND_PROFILE_LINK);
        }

        ProfileLink profileLink = profileLinkList.get(0);
        fcmUtil.sendReminder(profileLink);
    }

}
