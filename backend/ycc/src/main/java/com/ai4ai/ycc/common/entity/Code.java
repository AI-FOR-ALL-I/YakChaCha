package com.ai4ai.ycc.common.entity;

import javax.persistence.*;

@Entity
public class Code {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long codeSeq;

    @Column(nullable = false)
    private String code;

    @Column(nullable = false)
    private String name;

}
