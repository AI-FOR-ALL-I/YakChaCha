package com.ai4ai.ycc.domain.profile.entity;

import com.ai4ai.ycc.common.entity.BaseEntity;
import com.ai4ai.ycc.domain.account.entity.Account;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.*;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@ToString
@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
public class ProfileLink extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long profileLinkSeq;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_seq")
    private Account account;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_seq")
    private Account owner;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "profile_seq")
    private Profile profile;
    private String nickname;
    private int imgCode;

    @Builder
    public ProfileLink(Account account, Account owner, Profile profile, String nickname, int imgCode) {
        this.account = account;
        this.owner = owner;
        this.profile = profile;
        this.nickname = nickname;
        this.imgCode = imgCode;
    }
}
