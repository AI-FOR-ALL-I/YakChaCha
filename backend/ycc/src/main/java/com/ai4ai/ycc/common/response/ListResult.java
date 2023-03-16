package com.ai4ai.ycc.common.response;

import lombok.Setter;

import java.util.List;

@Setter
public class ListResult<T> extends Result {

    private List<T> data;

}
