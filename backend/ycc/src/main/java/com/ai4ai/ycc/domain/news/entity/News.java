package com.ai4ai.ycc.domain.news.entity;

import com.ai4ai.ycc.common.entity.BaseEntity;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.*;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@ToString
@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
public class News extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long newsSeq;

    private String url;
    private String img;
    private String title;
    private String description;

    @Builder
    public News(String url, String img, String title, String description) {
        this.url = url;
        this.img = img;
        this.title = title;
        this.description = description;
    }
}
