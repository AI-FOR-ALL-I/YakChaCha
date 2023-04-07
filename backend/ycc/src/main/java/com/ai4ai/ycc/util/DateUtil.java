package com.ai4ai.ycc.util;

import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.format.datetime.DateFormatter;
import org.springframework.stereotype.Component;

import java.text.DateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.time.temporal.ChronoField;
import java.util.Locale;

@Component
public class DateUtil {

    private String timeFormat = "hh:mm:a";
    private String dateFormat = "yyyy-MM-dd";
    private String dateTimeFormat = "yyyy-MM-dd HH:mm:ss";

    public LocalTime convertToTimeFormat(String time) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(timeFormat, Locale.ENGLISH);
        return LocalTime.parse(time, formatter);
    }
    public String convertToStringType(LocalTime time) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(timeFormat, Locale.ENGLISH);
        return time.format(formatter);
    }

    public LocalDate convertToDateFormat(String date) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(dateFormat);
        return LocalDate.parse(date, formatter);
    }

    public String convertToStringType(LocalDate date) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(dateFormat);
        return date.format(formatter);
    }

}
