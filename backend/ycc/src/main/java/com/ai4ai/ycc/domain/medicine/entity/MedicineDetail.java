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
	@Column(name="itemSeq", unique = true)
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long itemSeq;
	@Column(columnDefinition = "TEXT")
	private String materialName;
	@Column(columnDefinition = "TEXT")
	private String eeDocData;
	@Column(columnDefinition = "MEDIUMTEXT")
	private String udDocData;
	@Column(columnDefinition = "MEDIUMTEXT")
	private String nbDocData;

}
