package com.ai4ai.ycc.util.firebase;

import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.profile.entity.ProfileLink;
import com.google.firebase.messaging.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Component
@RequiredArgsConstructor
@Slf4j
public class FcmUtil {

    private final String imgURL = "https://jhs-aws-bucket.s3.ap-northeast-2.amazonaws.com/images/Image+Pasted+at+2023-3-16+16-58.png";

    public void sendLink(Account sender, Account receiver) {
        log.info("FCM Send Link...!!! {}", LocalDateTime.now());

        String title = "프로필 연동 요청";
        String body =  sender.getName() + "님이 프로필 연동을 요청했습니다.";

        Message message = Message.builder()
                .putData("senderName", sender.getName())
                .putData("senderAccountSeq", Long.toString(sender.getAccountSeq()))
                .putData("type", "link")
                .setNotification(Notification.builder()
                        .setTitle(title)
                        .setBody(body)
                        .setImage(imgURL)
                        .build())
                .setToken(receiver.getDeviceToken())
                .build();

        String response = null;

        try {
            response = FirebaseMessaging.getInstance().send(message);
            log.info("Success... sent message: {}", response);
        } catch (FirebaseMessagingException e) {
            log.warn("Fail... sent message");
            throw new RuntimeException(e);
        }
    }

    public void sendReminder(ProfileLink profileLink) {
        log.info("FCM Send Reminder...!!! {}", LocalDateTime.now());

        Account receiver = profileLink.getAccount();
        String nickname = profileLink.getNickname();

        String title = "약 먹을 시간";
        String body =  nickname + "님이 약 먹을 시간입니다..";

        Message message = Message.builder()
                .putData("profileLinkSeq", Long.toString(profileLink.getProfileLinkSeq()))
                .putData("type", "reminder")
                .setNotification(Notification.builder()
                        .setTitle(title)
                        .setBody(body)
                        .setImage(imgURL)
                        .build())
                .setToken(receiver.getDeviceToken())
                .build();

        String response = null;

        try {
            response = FirebaseMessaging.getInstance().send(message);
            log.info("Success... sent message: {}", response);
        } catch (FirebaseMessagingException e) {
            log.warn("Fail... sent message");
            throw new RuntimeException(e);
        }

    }

    public void sendReminder(List<Account> accountList) {
        log.info("FCM Send...!!! {}", LocalDateTime.now());

        String title = "리마인더";
        String body =  "약 먹을 시간입니다.";

        List<String> deviceTokens = new ArrayList<>();

        for (Account account : accountList) {
            deviceTokens.add(account.getDeviceToken());
        }

        MulticastMessage message = MulticastMessage.builder()
                .putData("type", "reminder")
                .setNotification(Notification.builder()
                        .setTitle(title)
                        .setBody(body)
                        .setImage(imgURL)
                        .build())
                .addAllTokens(deviceTokens)
                .build();

        BatchResponse response = null;

        try {
            response = FirebaseMessaging.getInstance().sendMulticast(message);
            log.info("Success... sent message...");
        } catch (FirebaseMessagingException e) {
            log.info("Fail... sent message...");
            throw new RuntimeException(e);
        }
    }

}
