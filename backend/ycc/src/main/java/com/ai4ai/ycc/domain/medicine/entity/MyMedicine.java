package com.ai4ai.ycc.domain.medicine.entity;

import java.time.LocalDate;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import com.ai4ai.ycc.common.entity.BaseEntity;
import com.ai4ai.ycc.domain.profile.entity.Profile;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@NoArgsConstructor
@Getter
@Builder
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
public class MyMedicine extends BaseEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "myMedicineSeq")
	private Long myMedicineSeq;


	@ManyToOne
	@JoinColumn(name = "profileSeq")
	private Profile profile;

	@ManyToOne
	@JoinColumn(name="medicineSeq")
	private Medicine medicine;

	@Column(columnDefinition = "datetime(6)")
	private LocalDate startDate;
	@Column(columnDefinition = "datetime(6)")
	private LocalDate endDate;

	@Column(length = 1)
	private String finish;

	public void modify(LocalDate startDate, LocalDate endDate) {
		this.startDate = startDate;
		this.endDate = endDate;
	}


}
