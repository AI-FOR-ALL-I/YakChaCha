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
public class MedicineDetail {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long medicineDetailSeq;
	@Column(columnDefinition = "TEXT")
	private String materialName;
	@Column(columnDefinition = "TEXT")
	private String eeDocData;
	@Column(columnDefinition = "MEDIUMTEXT")
	private String udDocData;
	@Column(columnDefinition = "MEDIUMTEXT")
	private String nbDocData;
	@Column(length = 22)
	private String entpName;
	@Column(length = 8)
	private String itemPermitDate;
	@Column(length = 5)
	private String etcOtcCode;
	@Column(length = 1000)
	private String chart;
	@Column(length = 36)
	private String classNo;

	@Column(length = 83)
	private String validTerm;
	@Column(length = 618)
	private String storageMethod;
	@Column(length = 615)
	private String packUnit;
	@Column(length = 8)
	private String changeDate;

	@Column(length = 2043)
	private String mainItemIngr;
	@Column(length = 3985)
	private String ingrName;
	//edi, itemName,img,typeCode,itemSeq
}
