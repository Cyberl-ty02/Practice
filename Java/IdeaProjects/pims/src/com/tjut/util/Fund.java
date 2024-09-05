package com.tjut.util;

public class Fund {

	private String contractno;
	private String contractname;
	private String budget;
	private String zxje;

	public Fund(String contractno, String contractname, String budget, String zxje) {
		super();
		this.contractno = contractno;
		this.contractname = contractname;
		this.budget = budget;
		this.zxje = zxje;
	}

	public String getContractno() {
		return contractno;
	}

	public void setContractno(String contractno) {
		this.contractno = contractno;
	}

	public String getContractname() {
		return contractname;
	}

	public void setContractname(String contractname) {
		this.contractname = contractname;
	}

	public String getBudget() {
		return budget;
	}

	public void setBudget(String budget) {
		this.budget = budget;
	}

	public String getZxje() {
		return zxje;
	}

	public void setZxje(String zxje) {
		this.zxje = zxje;
	}

}
