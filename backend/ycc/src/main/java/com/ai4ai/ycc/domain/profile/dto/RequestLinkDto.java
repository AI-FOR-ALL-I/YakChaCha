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

}
