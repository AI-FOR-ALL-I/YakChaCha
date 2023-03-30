package com.ai4ai.ycc.domain.profile.dto;

import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class RequestLinkDto {

    @Getter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @ToString
    public static class Account {
        private long accountSeq;
        private String name;
    }

    private Account sender;
    private Account receiver;
    private List<Integer> profiles;
    private String authNumber;

    // 1: S: 인증 요청 (expire: 30m)
    // 2: R: 요청 수락 (expire: 3m)
    // 3: S: 인증번호 확인 (expire: 10m)
    private int status;

    @Builder
    public RequestLinkDto(Account sender, Account receiver) {
        this.sender = sender;
        this.receiver = receiver;
        this.profiles = new ArrayList<>();
        this.authNumber = "";
        this.status = 1;
    }

    public void accept(List<Integer> profiles, String authNumber) {
        this.profiles = profiles;
        this.authNumber = authNumber;
        this.status++;
    }

    public void certify() {
        this.status++;
    }

}
