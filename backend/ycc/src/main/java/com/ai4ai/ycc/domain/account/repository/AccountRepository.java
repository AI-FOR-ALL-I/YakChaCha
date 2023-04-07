package com.ai4ai.ycc.domain.account.repository;

import com.ai4ai.ycc.domain.account.entity.Account;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AccountRepository extends JpaRepository<Account, Long> {

    boolean existsByIdAndDelYn(String id, String delYn);

    Account getByIdAndDelYn(String id, String delYn);

    Optional<Account> findByIdAndDelYn(String id, String delYn);

    Optional<Account> findByEmailAndDelYn(String email, String delYn);

    Optional<Account> findByAccountSeqAndDelYn(long accountSeq, String n);
}
