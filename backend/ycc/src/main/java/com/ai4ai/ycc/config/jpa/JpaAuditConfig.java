package com.ai4ai.ycc.config.jpa;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@Configuration
@EnableJpaAuditing
public class JpaAuditConfig {

//    @Bean
//    public AuditorAware<Long> auditorProvider() {
//        return new AuditorAwareImpl();
//    }

}
