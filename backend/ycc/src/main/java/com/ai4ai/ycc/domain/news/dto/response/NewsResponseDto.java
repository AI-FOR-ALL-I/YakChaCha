package com.ai4ai.ycc.domain.news.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class NewsResponseDto {

    private String url;
    private String img;
    private String title;
    private String description;

}
