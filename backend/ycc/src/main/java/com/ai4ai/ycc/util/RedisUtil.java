package com.ai4ai.ycc.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class RedisUtil {

    private final RedisTemplate<String, String> redisTemplate;

    public void save(String key, Object data)  {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            String value = objectMapper.writeValueAsString(data);
            log.info("[Redis] key: {}, value: {}", key, value);
            redisTemplate.opsForValue().set(key, value);
            log.info("[Redis] Save Success...");
        } catch (JsonProcessingException e) {
            log.warn("[Redis] Save Fail...");
            throw new RuntimeException(e);
        }
    }

    public <T> T get(String key, Class<T> valueType) {
        String value = redisTemplate.opsForValue().get(key);
        log.info("[Redis] key: {}, value: {}", key, value);

        if (value == null) {
            log.info("[Redis] Not Found Key...");
            return null;
        }

        try {
            ObjectMapper objectMapper = new ObjectMapper();
            T result = objectMapper.readValue(value, valueType);
            log.info("[Redis] Get Success...");
            return result;
        } catch(Exception e){
            log.warn("[Redis] Get Fail...");
            return null;
        }
    }

    public void delete(String key) {
        log.info("[Redis] Delete Key: {}...", key);
        redisTemplate.delete(key);
        log.info("[Redis] Delete Success...");
    }

}
