package com.ai4ai.ycc.domain.account.entity;

import com.fasterxml.jackson.annotation.JsonProperty;
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
@ToString(exclude = {"password"})
@EntityListeners(AuditingEntityListener.class)
@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
public class Account implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long accountSeq;

    @Column(nullable = false)
    private String type;

    @Column(nullable = false, unique = true)
    private String id;

    @Column(nullable = false, unique = true)
    private String email;

    private String refreshToken;

    @Column(nullable = false)
    private String delYn;

    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime regDttm;

    @LastModifiedDate
    private LocalDateTime modDttm;

    @Builder
    public Account(String type, String id, String email) {
        this.type = type;
        this.id = id;
        this.email = email;
    }

    @PrePersist
    public void setDefaultValues() {
        this.delYn = this.delYn == null ? "N" : this.delYn;
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
