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
public class Collision {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column
	private long collisionSeq;

	@Column(name = "medicine_a_id")
	private int medicineAId;

	@Column(name = "medicine_b_id")
	private int medicineBId;

	@Column
	private String aMaterial;
	@Column
	private String bMaterial;

	@Column
	private String detail;

}
