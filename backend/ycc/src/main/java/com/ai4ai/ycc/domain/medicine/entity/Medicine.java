package com.ai4ai.ycc.domain.medicine.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@NoArgsConstructor
@Getter
@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
public class Medicine {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(name="item_seq", unique = true)
	private Long itemSeq;
	@Column(length = 391)
	private String itemName;
	@Column(length = 22)
	private String entpName;
	@Column(length = 16)
	private String itemPermitDate;
	@Column(length = 5)
	private String etcOtcCode;
	@Column(length = 438)
	private String chart;
	@Column(length = 36)
	private String classNo;

	@Column(length = 78)
	private String validTerm;
	@Column(length = 189)
	private String storageMethod;
	@Column(length = 623)
	private String packUnit;
	@Column(length = 11)
	private String typeCode;
	@Column(length = 15)
	private String changeDate;

	@Column(length = 2043)
	private String mainItemIngr;
	@Column(length = 3495)
	private String ingrName;

	@Column
	private String img;


}
