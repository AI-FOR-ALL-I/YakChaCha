package com.ai4ai.ycc.config.jpa;

import lombok.*;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class AuthenticationUserDto {

    private Long accountSeq;
    private String id;
    private String phone;

}
