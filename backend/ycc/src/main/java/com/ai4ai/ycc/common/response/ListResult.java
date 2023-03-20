package com.ai4ai.ycc.common.response;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class ListResult<T> extends Result {

    private List<T> data;

}
