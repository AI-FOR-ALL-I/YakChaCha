package com.ai4ai.ycc.domain.profile.repository;

import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.profile.entity.ProfileLink;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProfileLinkRepository extends JpaRepository<ProfileLink, Long> {

    boolean existsByAccount(Account account);
    boolean existsByAccountAndProfile(Account account, Profile profile);

}
