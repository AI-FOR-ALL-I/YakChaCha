package com.ai4ai.ycc;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class YccApplication {

    public static void main(String[] args) {
        SpringApplication.run(YccApplication.class, args);
    }

}
