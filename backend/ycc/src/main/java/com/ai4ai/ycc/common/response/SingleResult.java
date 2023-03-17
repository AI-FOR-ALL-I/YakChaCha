package com.ai4ai.ycc.common.response;

import lombok.Setter;

@Setter
public class SingleResult<T> extends Result {

    private T data;

}
