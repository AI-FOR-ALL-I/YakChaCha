package com.ai4ai.ycc.domain.profile.service.impl;

import com.ai4ai.ycc.common.entity.BaseEntity;
import com.ai4ai.ycc.domain.account.entity.Account;
import com.ai4ai.ycc.domain.account.repository.AccountRepository;
import com.ai4ai.ycc.domain.profile.dto.RequestLinkDto;
import com.ai4ai.ycc.domain.profile.dto.request.*;
import com.ai4ai.ycc.domain.profile.dto.response.*;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.ai4ai.ycc.domain.profile.entity.ProfileLink;
import com.ai4ai.ycc.domain.profile.repository.ProfileLinkRepository;
import com.ai4ai.ycc.domain.profile.repository.ProfileRepository;
import com.ai4ai.ycc.domain.profile.service.ProfileLinkService;
import com.ai4ai.ycc.error.code.AccountErrorCode;
import com.ai4ai.ycc.error.code.ProfileErrorCode;
import com.ai4ai.ycc.error.code.ProfileLinkErrorCode;
import com.ai4ai.ycc.error.exception.ErrorException;
import com.ai4ai.ycc.util.DateUtil;

import java.util.*;

import com.ai4ai.ycc.util.RedisUtil;
import com.ai4ai.ycc.util.firebase.FcmUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalDate;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class ProfileLinkServiceImpl implements ProfileLinkService {

    private final AccountRepository accountRepository;
    private final ProfileRepository profileRepository;
    private final ProfileLinkRepository profileLinkRepository;
    private final DateUtil dateUtil;
    private final RedisUtil redisUtil;
    private final FcmUtil fcmUtil;

    @Override
    public void createProfileLink(Account account, Profile profile, CreateProfileRequestDto requestDto) {
        log.info("[createProfileLink] 본인 프로필 링크 생성");

        String nickname = requestDto.getNickname();
        int imgCode = requestDto.getImgCode();

        ProfileLink profileLink = ProfileLink.builder()
                .account(account)
                .owner(account)
                .profile(profile)
                .nickname(nickname)
                .imgCode(imgCode)
                .build();

        profileLinkRepository.save(profileLink);
        log.info("[createProfileLink] 본인 프로필 링크 생성 완료");
        
    }

    @Override
    public ProfileResponseDto getProfile(Account account, long profileLinkSeq) {
        ProfileLink profileLink = profileLinkRepository.findByAccountAndProfileLinkSeqAndDelYn(account, profileLinkSeq, "N")
                .orElseThrow(() -> new ErrorException(ProfileLinkErrorCode.NOT_FOUND_PROFILE_LINK));

        log.info("[getProfile] Profile 조회 시작");
        Profile profile = profileLink.getProfile();
        log.info("[getProfile] Profile 조회 완료 > {}", profile);

        boolean isOwner = account.getAccountSeq() == profileLink.getOwner().getAccountSeq();

        return ProfileResponseDto.builder()
                .profileLinkSeq(profileLink.getProfileLinkSeq())
                .imgCode(profileLink.getImgCode())
                .nickname(profileLink.getNickname())
                .name(profile.getName())
                .gender(profile.getGender())
                .isPregnancy(profile.isPregnancy())
                .birthDate(dateUtil.convertToStringType(profile.getBirthDate()))
                .isOwner(isOwner)
                .build();
    }

    @Override
    public List<ProfileResponseDto> getProfileList(Account account) {
        log.info("[getProfileList] 프로필 목록 조회");

        List<ProfileLink> profileLinkList = profileLinkRepository.findAllByAccountAndDelYn(account, "N");
        log.info("[getProfileList] ProfileLink 목록 조회 완료 > {}", profileLinkList);
        
        List<ProfileResponseDto> result = new ArrayList<>();

        for (ProfileLink profileLink : profileLinkList) {
            log.info("[getProfileList] Profile 조회 시작");
            Profile profile = profileLink.getProfile();
            log.info("[getProfileList] Profile 조회 완료 > {}", profile);

            boolean isOwner = account.getAccountSeq() == profileLink.getOwner().getAccountSeq();

            log.info("[getProfileList] Profile 추가 시작");
            result.add(ProfileResponseDto.builder()
                            .profileLinkSeq(profileLink.getProfileLinkSeq())
                            .imgCode(profileLink.getImgCode())
                            .nickname(profileLink.getNickname())
                            .name(profile.getName())
                            .gender(profile.getGender())
                            .isPregnancy(profile.isPregnancy())
                            .birthDate(dateUtil.convertToStringType(profile.getBirthDate()))
                            .isOwner(isOwner)
                            .build());
            log.info("[getProfileList] Profile 추가 완료");
        }

        log.info("[getProfileList] 프로필 목록 조회 완료");

        return result;
    }

    @Override
    public void modifyProfile(Account account, long profileLinkSeq, ModifyProfileRequestDto requestDto) {
        log.info("[modifyProfile] Profile 수정 시작");

        ProfileLink profileLink = profileLinkRepository.findByAccountAndProfileLinkSeqAndDelYn(account, profileLinkSeq, "N")
                .orElseThrow(() -> new ErrorException(ProfileLinkErrorCode.NOT_FOUND_PROFILE_LINK));

        Profile profile = profileLink.getProfile();

        int imgCode = requestDto.getImgCode();
        String nickname = requestDto.getNickname();
        String name = requestDto.getName();
        String gender = requestDto.getGender();
        boolean pregnancy = requestDto.isPregnancy();
        LocalDate birthDate = dateUtil.convertToDateFormat(requestDto.getBirthDate());

        profileLink.modify(imgCode, nickname);
        profile.modify(name, gender, pregnancy, birthDate);

//        profileLinkRepository.save(profileLink);
//        profileRepository.save(profile);

        log.info("[modifyProfile] Profile 수정 완료 > {}", profile);
    }

    @Override
    public void removeProfile(Account account, long profileLinkSeq) {
        log.info("[removeProfile] Profile 삭제");

        ProfileLink profileLink = profileLinkRepository.findByAccountAndProfileLinkSeqAndDelYn(account, profileLinkSeq, "N")
                .orElseThrow(() -> new ErrorException(ProfileLinkErrorCode.NOT_FOUND_PROFILE_LINK));

        Profile profile = profileLink.getProfile();

        List<ProfileLink> profileLinkList = profileLinkRepository.findAllByProfileAndDelYn(profile, "N");

        profileLinkList.forEach(BaseEntity::remove);

        profile.remove();

        log.info("[removeProfile] Profile 삭제 완료");
    }

    @Transactional
    @Override
    public void removeAllProfile(Account account) {
        //List<ProfileLink> profileLinkList = profileLinkRepository.findAllByAccountOrOwnerAndDelYn(account, account, "N");
        List<ProfileLink> profileLinkList = profileLinkRepository.findAllByAccount(account);
        Set<Profile> profileSet = new HashSet<>();
        profileLinkList.forEach(profileLink -> {
            if (profileLink.getAccount().getAccountSeq() == profileLink.getOwner().getAccountSeq()) {
                Profile profile = profileLink.getProfile();
                profileSet.add(profile);
            }
            profileLink.remove();
        });
        profileSet.forEach(BaseEntity::remove);
    }

    @Override
    public void sendLink(Account sender, SendLinkRequestDto requestDto) {
        log.info("[sendLink] 프로필 연동 요청 보내기 시작");
        
        String email = requestDto.getEmail();

        Account receiver = accountRepository.findByEmailAndDelYn(email, "N")
                .orElseThrow(() -> new ErrorException(AccountErrorCode.ACCOUNT_NOT_FOUND));

        if (sender.getAccountSeq() == receiver.getAccountSeq()) {
            throw new ErrorException(AccountErrorCode.YOUR_ACCOUNT);
        }

        RequestLinkDto requestLinkDto = RequestLinkDto.builder()
                .sender(RequestLinkDto.Account.builder()
                        .accountSeq(sender.getAccountSeq())
                        .name(sender.getName())
                        .build())
                .receiver(RequestLinkDto.Account.builder()
                        .accountSeq(receiver.getAccountSeq())
                        .name(receiver.getName())
                        .build())
                .build();
        
        log.info("[sendLink] Redis 저장 시작");
        String key = "requestLink:" + sender.getAccountSeq();
        redisUtil.setex(key, requestLinkDto, 1800);
        log.info("[sendLink] Redis 저장 완료");

        log.info("[sendLink] 푸시 알림 보내기 시작");
        fcmUtil.sendLink(sender, receiver);
        log.info("[sendLink] 푸시 알림 보내기 완료");

        log.info("[sendLink] 프로필 연동 요청 보내기 완료");
    }

    @Override
    public ConfirmLinkResponseDto confirmLink(Account account, long senderAccountSeq) {
        Account sender = accountRepository.findByAccountSeqAndDelYn(senderAccountSeq, "N")
                .orElseThrow(() -> new ErrorException(AccountErrorCode.ACCOUNT_NOT_FOUND));

        String key = "requestLink:" + senderAccountSeq;

        log.info("[confirmLink] redis 조회 시작");
        RequestLinkDto requestLink = redisUtil.get(key, RequestLinkDto.class);
        log.info("[confirmLink] redis 조회 완료");

        if (requestLink == null || requestLink.getStatus() != 1 || requestLink.getReceiver().getAccountSeq() != account.getAccountSeq()) {
            throw new ErrorException(ProfileLinkErrorCode.NOT_FOUND_LINK);
        }

        String senderAccountName = requestLink.getSender().getName();

        log.info("[confirmLink] 요청 목록 조회");
        List<ProfileLink> profileLinkList = profileLinkRepository.findAllByAccountAndDelYn(account, "N");
        log.info("[confirmLink] ProfileLink 목록 조회 완료 > {}", profileLinkList);

        List<ProfileLinkResponseDto> profiles = new ArrayList<>();

        for (ProfileLink profileLink : profileLinkList) {
            log.info("[confirmLink] Profile 조회 시작");
            Profile profile = profileLink.getProfile();
            log.info("[confirmLink] Profile 조회 완료 > {}", profile);

            int status = 0;

            boolean isOwner = account.getAccountSeq() == profileLink.getOwner().getAccountSeq();

            if (isOwner) {
                if (!profileLinkRepository.existsByAccountAndProfileAndDelYn(sender, profile, "N")) {
                    log.info("[confirmLink] 연동 가능한 프로필입니다.");
                    status = 1;
                } else {
                    log.info("[confirmLink] 상대방이 이미 연동중인 프로필입니다.");
                    status = 2;
                }
            } else {
                log.info("[confirmLink] 본인 프로필이 아닙니다.");
            }

            log.info("[confirmLink] Profile 추가 시작");
            profiles.add(ProfileLinkResponseDto.builder()
                    .profileLinkSeq(profileLink.getProfileLinkSeq())
                    .imgCode(profileLink.getImgCode())
                    .nickname(profileLink.getNickname())
                    .name(profile.getName())
                    .gender(profile.getGender())
                    .isPregnancy(profile.isPregnancy())
                    .birthDate(dateUtil.convertToStringType(profile.getBirthDate()))
                    .status(status)
                    .build());
            log.info("[confirmLink] Profile 추가 완료");
        }

        log.info("[confirmLink] 프로필 목록 조회 완료");

        log.info("[confirmLink] 요청 목록 완료");

        return ConfirmLinkResponseDto.builder()
                .senderAccountSeq(senderAccountSeq)
                .senderAccountName(senderAccountName)
                .profiles(profiles)
                .build();
    }

    @Override
    public void acceptLink(Account account, long senderAccountSeq, AcceptLinkRequestDto requestDto) {
        List<Long> profiles = requestDto.getProfiles();

        String key = "requestLink:" + senderAccountSeq;

        log.info("[confirmLink] redis 조회 시작");
        RequestLinkDto requestLink = redisUtil.get(key, RequestLinkDto.class);
        log.info("[confirmLink] redis 조회 완료");

        if (requestLink == null || requestLink.getStatus() != 1 || requestLink.getReceiver().getAccountSeq() != account.getAccountSeq()) {
            throw new ErrorException(ProfileLinkErrorCode.NOT_FOUND_LINK);
        }

        String authNumber = generateAuthNumber();
        requestLink.accept(profiles, authNumber);
        
        log.info("[confirmLink] redis 저장 시작");
        redisUtil.setex(key, requestLink, 180);
        log.info("[confirmLink] redis 저장 시작");
        
    }

    @Override
    public FindAuthNumberResponseDto findAuthNumber(Account account, long senderAccountSeq) {
        String key = "requestLink:" + senderAccountSeq;

        log.info("[confirmLink] redis 조회 시작");
        RequestLinkDto requestLink = redisUtil.get(key, RequestLinkDto.class);
        log.info("[confirmLink] redis 조회 완료");

        if (requestLink == null || requestLink.getStatus() != 2 || requestLink.getReceiver().getAccountSeq() != account.getAccountSeq()) {
            throw new ErrorException(ProfileLinkErrorCode.NOT_FOUND_LINK);
        }

        String senderName = requestLink.getSender().getName();
        String authNumber = requestLink.getAuthNumber();

        return FindAuthNumberResponseDto.builder()
                .senderName(senderName)
                .authNumber(authNumber)
                .build();
    }

    @Override
    public void checkAuthNumber(Account account, CheckAuthNumberRequestDto requestDto) {
        String key = "requestLink:" + account.getAccountSeq();

        log.info("[checkAuthNumber] redis 조회 시작");
        RequestLinkDto requestLink = redisUtil.get(key, RequestLinkDto.class);
        log.info("[checkAuthNumber] redis 조회 완료");

        if (requestLink == null || requestLink.getStatus() != 2) {
            throw new ErrorException(ProfileLinkErrorCode.NOT_FOUND_LINK);
        }

        String authNumber = requestDto.getAuthNumber();

        log.info("[checkAuthNumber] 인증번호 확인 시작");
        if (!requestLink.getAuthNumber().equals(authNumber)) {
            throw new ErrorException(ProfileLinkErrorCode.INVALID_AUTH_NUMBER);
        }
        requestLink.certify();
        log.info("[checkAuthNumber] 인증번호 확인 완료");

        log.info("[checkAuthNumber] redis 저장 완료");
        redisUtil.setex(key, requestLink, 600);
        log.info("[checkAuthNumber] redis 저장 완료");

    }

    @Override
    public List<ReceiverProfileResponseDto> getRecieverProfileList(Account account) {
        String key = "requestLink:" + account.getAccountSeq();

        log.info("[checkAuthNumber] redis 조회 시작");
        RequestLinkDto requestLink = redisUtil.get(key, RequestLinkDto.class);
        log.info("[checkAuthNumber] redis 조회 완료");

        if (requestLink == null || requestLink.getStatus() != 3) {
            throw new ErrorException(ProfileLinkErrorCode.NOT_FOUND_LINK);
        }

        long receiverAccountSeq = requestLink.getReceiver().getAccountSeq();
        Account receiver = accountRepository.findByAccountSeqAndDelYn(receiverAccountSeq, "N")
                .orElseThrow(() -> new ErrorException(AccountErrorCode.ACCOUNT_NOT_FOUND));

        List<ReceiverProfileResponseDto> result = new ArrayList<>();

        List<Long> profiles = requestLink.getProfiles();
        for (Long profileSeq : profiles) {
            Profile profile = profileRepository.findByProfileSeqAndDelYn(profileSeq, "N")
                    .orElseThrow(() -> new ErrorException(ProfileErrorCode.PROFILE_NOT_FOUND));

            ProfileLink profileLink = profileLinkRepository.findByOwnerAndProfileAndDelYn(receiver, profile, "N")
                            .orElseThrow(() -> new ErrorException(ProfileLinkErrorCode.NOT_FOUND_PROFILE_LINK));

            result.add(ReceiverProfileResponseDto.builder()
                            .profileSeq(profileSeq)
                            .imgCode(profileLink.getImgCode())
                            .nickname(profileLink.getNickname())
                            .name(profile.getName())
                            .gender(profile.getGender())
                            .birthDate(dateUtil.convertToStringType(profile.getBirthDate()))
                            .isPregnancy(profile.isPregnancy())
                    .build());
        }

        return result;
    }

    @Override
    public void linkProfiles(Account account, List<LinkProfileRequestDto> requestDto) {
        log.info("[linkProfiles] 프로필 연동 등록 시작");
        
        String key = "requestLink:" + account.getAccountSeq();

        log.info("[linkProfiles] redis 조회 시작");
        RequestLinkDto requestLink = redisUtil.get(key, RequestLinkDto.class);
        log.info("[linkProfiles] redis 조회 완료");

        if (requestLink == null || requestLink.getStatus() != 3) {
            throw new ErrorException(ProfileLinkErrorCode.NOT_FOUND_LINK);
        }

        long receiverAccountSeq = requestLink.getReceiver().getAccountSeq();
        Account receiver = accountRepository.findByAccountSeqAndDelYn(receiverAccountSeq, "N")
                .orElseThrow(() -> new ErrorException(AccountErrorCode.ACCOUNT_NOT_FOUND));

        for (LinkProfileRequestDto linkProfile : requestDto) {
            Profile profile = profileRepository.findByProfileSeqAndDelYn(linkProfile.getProfileSeq(), "N")
                    .orElseThrow(() -> new ErrorException(ProfileErrorCode.PROFILE_NOT_FOUND));

            ProfileLink profileLink = ProfileLink.builder()
                    .account(account)
                    .owner(receiver)
                    .profile(profile)
                    .nickname(linkProfile.getNickname())
                    .imgCode(linkProfile.getImgCode())
                    .build();

            profileLinkRepository.save(profileLink);
        }
        log.info("[linkProfiles] 프로필 연동 등록 완료");
    }


    public String generateAuthNumber() {
        log.info("[generateAuthNumber] 인증번호 생성 시작");
        int authNumber = (int)(Math.random() * 900000) + 100000;
        log.info("[generateAuthNumber] 인증번호 생성 완료");
        return String.valueOf(authNumber);
    }

}
