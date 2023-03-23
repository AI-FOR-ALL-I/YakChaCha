package com.ai4ai.ycc.util.firebase;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import okhttp3.*;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;

import java.io.FileInputStream;
import java.util.Arrays;

@Component
@RequiredArgsConstructor
@Slf4j
public class FcmUtil {
    private final String API_URL = "https://fcm.googleapis.com/v1/projects/yakchacha/messages:send";
    private final ObjectMapper objectMapper;

    private String getAccessToken() throws Exception {
        GoogleCredentials googleCredentials = GoogleCredentials
                .fromStream(new FileInputStream("src/main/resources/firebase/service-key.json"))
                .createScoped(Arrays.asList("https://www.googleapis.com/auth/cloud-platform"));
        googleCredentials.refreshIfExpired();

        return googleCredentials.getAccessToken().getTokenValue();
    }

    public void sendFcmMessage(String targetToken, String title, String body) throws Exception {
        String message = makeMessage(targetToken, title, body);

        OkHttpClient client = new OkHttpClient();
        RequestBody requestBody = RequestBody.create(message, MediaType.get("application/json; charset=utf-8"));
        Request request = new Request.Builder()
                .url(API_URL)
                .post(requestBody)
                .addHeader(HttpHeaders.AUTHORIZATION, "Bearer " + getAccessToken())
                .build();

        Response response = client.newCall(request)
                .execute();

        log.info("[FCM] Response: {}", response.body().string());
    }

    private String makeMessage(String targetToken, String title, String body) throws Exception {
        FcmMessage fcmMessage = FcmMessage.builder()
                .message(FcmMessage.Message.builder()
                        .token(targetToken)
                        .notification(FcmMessage.Notification.builder()
                                .title(title)
                                .body(body)
                                .image(null)
                                .build()
                        )
                        .build()
                )
                .validate_only(false)
                .build();

        return objectMapper.writeValueAsString(fcmMessage);
    }

}
