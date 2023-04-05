package com.ai4ai.ycc.domain.profile.repository;

import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.profile.entity.ProfileLink;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ProfileLinkRepository extends JpaRepository<ProfileLink, Long> {

    boolean existsByAccountAndDelYn(Account account, String delYn);
    boolean existsByAccountAndProfile(Account account, Profile profile);

    @EntityGraph(attributePaths = {"account", "profile"})
    Optional<ProfileLink> findByAccountAndProfileLinkSeqAndDelYn(Account account, long profileLinkSeq, String delYn);

    @EntityGraph(attributePaths = {"account", "profile"})
    List<ProfileLink> findAllByAccountAndDelYn(Account account, String delYn);

    @EntityGraph(attributePaths = {"account", "profile"})
    List<ProfileLink> findAllByAccountOrOwnerAndDelYn(Account account, Account owner, String delYn);

    @EntityGraph(attributePaths = {"account", "profile"})
    @Query("select pl from ProfileLink pl where (pl.account = :account or pl.owner = :account) and pl.delYn = 'N'")
    List<ProfileLink> findAllByAccount(@Param("account") Account account);

    @EntityGraph(attributePaths = {"account", "profile"})
    List<ProfileLink> findAllByProfileAndDelYn(Profile profile, String delYn);

    boolean existsByAccountAndProfileAndDelYn(Account sender, Profile profile, String delYn);
    ProfileLink findByAccountAndOwnerAndDelYn(Account sender, Account account, String delYn);

    Optional<ProfileLink> findByOwnerAndProfileAndDelYn(Account owner, Profile profile, String delYn);

    Optional<ProfileLink> findByProfileLinkSeqAndDelYn(long profileLinkSeq, String n);

    Optional<ProfileLink> findByOwnerAndProfileLinkSeqAndDelYn(Account owner, long profileLinkSeq, String delYn);
}
