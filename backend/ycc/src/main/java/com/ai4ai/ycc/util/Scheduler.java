package com.ai4ai.ycc.util;

import com.ai4ai.ycc.domain.medicine.service.MedicineService;
import com.ai4ai.ycc.domain.reminder.service.ReminderService;
import com.ai4ai.ycc.util.firebase.FcmUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
@Slf4j
@RequiredArgsConstructor
public class Scheduler {

    private final FcmUtil fcmUtil;
    private final ReminderService reminderService;
    private final MedicineService medicineService;
    private final String token = "dl-SqL3hRoyun8rN3ro6CF:APA91bHvk7ZdsBD7hzQbqz7n2fTVrcn1522zUaoCawnds2Rr6-rREtgswHqUDCLV3pKbjywXIAJC-0HKoCot7ABnFUR8-e_wuLCKDMOKH3Z7mlwn_ra4ui_kI_LJ1mNhqvsO3wV_Gd-N";

    // 0시 0분 0초에 리마인더 초기화
    @Scheduled(cron = "0 0 0 * * *")
    public void reminderReset() {
        reminderService.resetReminder();
    }

    @Scheduled(cron = "1 0 0 * * *")
    public void myMedicineTaken() { medicineService.takenMyMedicine();}


//    @Scheduled(cron = "0 0/1 * * * *")
    public void test() throws Exception {
        log.warn("TEST!!! {}", LocalDateTime.now());
//        fcmUtil.sendFcmMessage(token, "누구게!!", "맞춰봐!!");
    }


}
