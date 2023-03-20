package com.ai4ai.ycc.domain.account.repository;

import com.ai4ai.ycc.domain.account.entity.Account;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AccountRepository extends JpaRepository<Account, Long> {

    boolean existsById(String id);
    boolean existsByPhone(String id);

    Optional<Account> findById(String id);
    Optional<Account> findByPhone(String phone);
    Optional<Account> findByIdAndPhone(String id, String phone);

}
