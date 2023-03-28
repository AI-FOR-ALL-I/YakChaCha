package com.ai4ai.ycc.domain.account.entity;

import com.ai4ai.ycc.common.entity.BaseAccountEntity;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Collection;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED) // 아무런 값도 갖지않는 의미 없는 객체의 생성을 막음.
@ToString(exclude = "refreshToken")
@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
public class Account extends BaseAccountEntity implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long accountSeq;

    @Column(nullable = false)
    private String type;

    @Column(nullable = false)
    private String id;

    @Column(nullable = false)
    private String email;

    private String refreshToken;

    private String deviceToken;

    @Builder
    public Account(String type, String id, String email, String deviceToken) {
        this.type = type;
        this.id = id;
        this.email = email;
        this.deviceToken = deviceToken;
    }

    public void login(String refreshToken, String deviceToken) {
        this.refreshToken = refreshToken;
        this.deviceToken = deviceToken;
    }

    public void logout() {
        this.refreshToken = null;
        this.deviceToken = null;
    }

    public void putRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }

    public void removeRefreshToken() {
        this.refreshToken = null;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return null;
    }

    @Override
    public String getUsername() {
        return this.id;
    }
    @Override
    public String getPassword() {
        return null;
    }

    @Override
    public boolean isAccountNonExpired() {
        return false;
    }

    @Override
    public boolean isAccountNonLocked() {
        return false;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return false;
    }

    @Override
    public boolean isEnabled() {
        return false;
    }

}
