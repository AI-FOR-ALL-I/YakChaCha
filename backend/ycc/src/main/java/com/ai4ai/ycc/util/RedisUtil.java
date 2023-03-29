package com.ai4ai.ycc.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
@Slf4j
public class RedisUtil {

    private final RedisTemplate<String, String> redisTemplate;

    public <T> T get(String key, Class<T> valueType) {
        String value = redisTemplate.opsForValue().get(key);
        log.info("[Get] key: {}, value: {}", key, value);

        if (value == null) {
            log.info("[Get] Not Found Key...");
            return null;
        }

        try {
            ObjectMapper objectMapper = new ObjectMapper();
            T result = objectMapper.readValue(value, valueType);
            log.info("[Get] Success...");
            return result;
        } catch(Exception e){
            log.warn("[Get] Fail...");
            return null;
        }
    }

    public void set(String key, Object data)  {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            String value = objectMapper.writeValueAsString(data);
            log.info("[Set] key: {}, value: {}", key, value);
            redisTemplate.opsForValue().set(key, value);
            log.info("[Set] Success...");
        } catch (JsonProcessingException e) {
            log.warn("[Set] Fail...");
            throw new RuntimeException(e);
        }
    }

    public void setex(String key, Object data, int expireSeconds)  {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            String value = objectMapper.writeValueAsString(data);
            log.info("[SetEx] key: {}, value: {}, expire: {}s", key, value, expireSeconds);
            redisTemplate.opsForValue().set(key, value, expireSeconds, TimeUnit.SECONDS);
            log.info("[SetEx] Success...");
        } catch (JsonProcessingException e) {
            log.warn("[SetEx] Fail...");
            throw new RuntimeException(e);
        }
    }

    public void expire(String key, int expireSeconds) {
        log.info("[Expire] Key: {}...", key);
        redisTemplate.expire(key, expireSeconds, TimeUnit.SECONDS);
        log.info("[Expire] Success...");
    }

    public void delete(String key) {
        log.info("[Delete] Key: {}...", key);
        redisTemplate.delete(key);
        log.info("[Delete] Success...");
    }

}
