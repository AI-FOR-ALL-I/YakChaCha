package com.ai4ai.ycc.domain.account.entity;

import com.ai4ai.ycc.common.entity.BaseEntity;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.*;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED) // 아무런 값도 갖지않는 의미 없는 객체의 생성을 막음.
@ToString(exclude = {"password"})
@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
public class Account extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long accountSeq;

    @Column(nullable = false, unique = true)
    private String id;

    @Column(nullable = false)
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;

    @Column(nullable = false, unique = true)
    private String phoneNumber;

    public void updatePhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    @Builder
    public Account(String id, String password, String phoneNumber) {
        this.id = id;
        this.password = password;
        this.phoneNumber = phoneNumber;
    }

}
