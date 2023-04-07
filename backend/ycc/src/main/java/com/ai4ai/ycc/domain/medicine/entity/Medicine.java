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
	private long medicineSeq;

	@Column(unique = true)
	private long itemSeq;
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="medicine_detail_seq")
	private MedicineDetail detail;
	@Column(length = 391)
	private String itemName;
	@Column(length = 149)
	private String ediCode;
	@Column(length = 35)
	private String typeCode;
	@Column(length = 70)
	private String img;


}
