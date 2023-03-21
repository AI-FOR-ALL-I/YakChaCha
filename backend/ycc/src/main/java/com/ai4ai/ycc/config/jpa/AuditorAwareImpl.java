package com.ai4ai.ycc.config.jpa;

import com.ai4ai.ycc.domain.account.entity.Account;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.AuditorAware;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.Optional;

@Slf4j
public class AuditorAwareImpl implements AuditorAware<Long> {

    @Override
    public Optional<Long> getCurrentAuditor() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            log.debug("Not found AuthenticationToken");
            return null;
        }

        Account account = (Account) authentication.getDetails();
        log.debug("Found AuthenticationToken: {}", account);
        return Optional.of(account.getAccountSeq());
    }

}
