package com.ai4ai.ycc.domain.medicine.entity;

import java.time.LocalDate;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;

import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@NoArgsConstructor
@Getter
@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
public class MyMedicine {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long myMedicineSeq;

	@Column
	private Long profileSeq;
	@ManyToOne
	@JoinColumn(name="medicine_seq")
	private Medicine medicine;
	@Column(columnDefinition = "TIME")
	private LocalDate startDate;
	@Column(columnDefinition = "TIME")
	private LocalDate endDate;
	@Column(length = 1)
	private String delYn;
	@Column(columnDefinition = "TIME")
	private LocalDate regDttm;
	@Column
	private Long regAccountSeq;
	@Column(length = 8)
	private String modDttm;
	@Column
	private Long modAccountSeq;
}
