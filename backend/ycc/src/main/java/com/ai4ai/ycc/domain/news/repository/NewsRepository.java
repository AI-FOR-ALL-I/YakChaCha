package com.ai4ai.ycc.domain.news.repository;

import com.ai4ai.ycc.domain.news.entity.News;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NewsRepository extends JpaRepository<News, Long> {

    List<News> findByDelYn(String delYn);
}
