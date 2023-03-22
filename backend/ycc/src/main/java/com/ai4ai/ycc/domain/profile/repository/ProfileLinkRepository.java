package com.ai4ai.ycc.domain.profile.repository;

import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.profile.entity.ProfileLink;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ProfileLinkRepository extends JpaRepository<ProfileLink, Long> {

    boolean existsByAccount(Account account);
    boolean existsByAccountAndProfile(Account account, Profile profile);

    @EntityGraph(attributePaths = {"account", "profile"})
    Optional<ProfileLink> findByAccountAndProfileLinkSeqAndDelYn(Account account, long profileLinkSeq, String delYn);

    @EntityGraph(attributePaths = {"account", "profile"})
    List<ProfileLink> findAllByAccountAndDelYn(Account account, String delYn);

    @EntityGraph(attributePaths = {"account", "profile"})
    List<ProfileLink> findAllByProfileAndDelYn(Profile profile, String delYn);

}
