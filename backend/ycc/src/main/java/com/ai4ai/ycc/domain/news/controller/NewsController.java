package com.ai4ai.ycc.domain.news.controller;

import com.ai4ai.ycc.common.response.ResponseService;
import com.ai4ai.ycc.common.response.Result;
import com.ai4ai.ycc.domain.news.dto.response.NewsResponseDto;
import com.ai4ai.ycc.domain.news.service.NewsService;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import okhttp3.Response;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/news")
@RequiredArgsConstructor
@Slf4j
public class NewsController {

    private final ResponseService responseService;
    private final NewsService newsService;

    @GetMapping
    public ResponseEntity<Result> getNewsList() {
        List<NewsResponseDto> result = newsService.getNewsList();
        return ResponseEntity.ok()
                .body(responseService.getListResult(result));
    }

}
