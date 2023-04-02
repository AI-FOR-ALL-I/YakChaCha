package com.ai4ai.ycc.util;

import com.ai4ai.ycc.domain.medicine.service.MedicineService;
import com.ai4ai.ycc.domain.reminder.service.ReminderService;
import com.ai4ai.ycc.util.firebase.FcmUtil;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import java.time.LocalTime;
import java.util.List;
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
    private final DateUtil dateUtil;
    private final ReminderService reminderService;
    private final MedicineService medicineService;
    private final String token = "dl-SqL3hRoyun8rN3ro6CF:APA91bHvk7ZdsBD7hzQbqz7n2fTVrcn1522zUaoCawnds2Rr6-rREtgswHqUDCLV3pKbjywXIAJC-0HKoCot7ABnFUR8-e_wuLCKDMOKH3Z7mlwn_ra4ui_kI_LJ1mNhqvsO3wV_Gd-N";
    private final String jhToken = "du7kLIHQQZqA9SNZYzv5W9:APA91bG80ObTfm3UhKyrmmGrp-yDYzzAjWQPU-TjCcocp9zDIBqBQl-XmjntFAXn_irkUJUhaWQFQQhRn7lJ9iC-9OGVX-KmEHCxBv4gKs87XSl8jYhfuIsiA2tDyq9Fyw74LyaWuIfx";
    private final String djToken = "f3At3KCHT8yLj9UGONWpL0:APA91bGYFFiUcPQPemdNOXXxHDWHucDciUkdonKLdYVEo5gzGJzhF9uHgVVC4addOvx6jYEGL614IHvERGLZt0oi2_0pXVLu9BBtiE0UplfWKeToXqyzLZ03_2WUi_ziwFAxxvWMWq4b";
    private final String imgURL = "https://jhs-aws-bucket.s3.ap-northeast-2.amazonaws.com/images/Image+Pasted+at+2023-3-16+16-58.png";

    // 0시 0분 0초에 리마인더 초기화
    @Scheduled(cron = "0 0 0 * * *")
    public void reminderReset() {
        reminderService.resetReminder();
    }

    @Scheduled(cron = "1 0 0 * * *")
    public void myMedicineTaken() { medicineService.takenMyMedicine();}


//    @Scheduled(cron = "0 0/1 * * * *")
    public void test() throws Exception {
        LocalTime now = LocalTime.now();
        String time = dateUtil.convertToStringType(now);
        log.info("리마인더 알림 보내기 !!! {}", time);
        List<ProfileLink> profileLinkList = reminderService.getProfileLinkListAtTime(time);

        for (ProfileLink profileLink : profileLinkList) {
            fcmUtil.sendReminder(profileLink);
        }
    }

}
