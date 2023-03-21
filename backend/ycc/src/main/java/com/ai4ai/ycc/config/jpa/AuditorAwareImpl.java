package com.ai4ai.ycc.config.jpa;

import com.ai4ai.ycc.domain.account.entity.Account;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.AuditorAware;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.Optional;

@Slf4j
public class AuditorAwareImpl implements AuditorAware<Long> {

    @Override
    public Optional<Long> getCurrentAuditor() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || authentication instanceof AnonymousAuthenticationToken) {
            log.debug("Not found AuthenticationToken");
            return null;
        }

        log.warn(authentication.toString());
        log.warn(authentication.getPrincipal().toString());
        Account account = (Account) authentication.getPrincipal();
        log.warn(account.toString());
//        log.info(authentication.getDetails().toString());
//        log.info(authentication.getPrincipal().toString());
//        Account account = (Account) authentication.getDetails().;
//        log.debug("Found AuthenticationToken: {}", account);
//        return Optional.of(account.getAccountSeq());
        return Optional.of(account.getAccountSeq());
    }

}
