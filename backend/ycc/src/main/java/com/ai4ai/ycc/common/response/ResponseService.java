package com.ai4ai.ycc.common.response;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(readOnly = true)
public class ResponseService {

    private static final String SUCCESS_MSG = "요청에 성공하셨습니다.";

    public void setSuccessResult(Result result) {
        result.setSuccess(true);
        result.setMessage(SUCCESS_MSG);
    }

    public Result getSuccessResult() {
        Result result = new Result();
        setSuccessResult(result);
        return result;
    }

    public <T> SingleResult<T> getSingleResult(T data) {
        SingleResult<T> result = new SingleResult<>();
        setSuccessResult(result);
        result.setData(data);
        return result;
    }

    public <T> ListResult<T> getListResult(List<T> data) {
        ListResult<T> result = new ListResult<>();
        setSuccessResult(result);
        result.setData(data);
        return result;
    }

}
