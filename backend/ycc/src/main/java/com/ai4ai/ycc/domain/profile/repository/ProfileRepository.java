package com.ai4ai.ycc.domain.profile.repository;

import com.ai4ai.ycc.domain.profile.entity.Profile;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ProfileRepository extends JpaRepository<Profile, Long> {


    Optional<Profile> findByProfileSeqAndDelYn(long profileSeq, String n);
}
