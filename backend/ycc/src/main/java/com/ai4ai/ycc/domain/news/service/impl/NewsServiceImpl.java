package com.ai4ai.ycc.domain.news.service.impl;

import com.ai4ai.ycc.domain.news.dto.response.NewsResponseDto;
import com.ai4ai.ycc.domain.news.entity.News;
import com.ai4ai.ycc.domain.news.repository.NewsRepository;
import com.ai4ai.ycc.domain.news.service.NewsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class NewsServiceImpl implements NewsService {

    private final NewsRepository newsRepository;

    @Override
    public List<NewsResponseDto> getNewsList() {
        log.info("[getNewsList] 뉴스 목록 조회");
        List<News> newsList = newsRepository.findByDelYn("N");

        List<NewsResponseDto> result = new ArrayList<>();

        for (News news : newsList) {
            result.add(NewsResponseDto.builder()
                            .url(news.getUrl())
                            .img(news.getImg())
                            .title(news.getTitle())
                            .description(news.getDescription())
                    .build());
        }

        log.info("[getNewsList] 뉴스 목록 조회 완료");

        return result;
    }

}
