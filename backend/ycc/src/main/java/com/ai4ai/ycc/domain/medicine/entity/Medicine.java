package com.ai4ai.ycc.domain.medicine.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;

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
	private Long medicineSeq;

	@Column
	private Long itemSeq;
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="medicine_detail_seq")
	private MedicineDetail detail;
	@Column(length = 391)
	private String itemName;
	@Column(length = 22)
	private String entpName;
	@Column(length = 8)
	private String itemPermitDate;
	@Column(length = 5)
	private String etcOtcCode;
	@Column(length = 1000)
	private String chart;
	@Column(length = 255)
	private String classNo;

	@Column(length = 83)
	private String validTerm;
	@Column(length = 618)
	private String storageMethod;
	@Column(length = 615)
	private String packUnit;
	@Column(length = 200)
	private String typeCode;
	@Column(length = 15)
	private String changeDate;

	@Column(length = 2043)
	private String mainItemIngr;
	@Column(length = 3985)
	private String ingrName;

	@Column
	private String img;


}
