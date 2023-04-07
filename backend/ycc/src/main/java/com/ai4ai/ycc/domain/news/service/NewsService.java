package com.ai4ai.ycc.domain.news.service;

import com.ai4ai.ycc.domain.news.dto.response.NewsResponseDto;

import java.util.List;

public interface NewsService {

    List<NewsResponseDto> getNewsList();

}
