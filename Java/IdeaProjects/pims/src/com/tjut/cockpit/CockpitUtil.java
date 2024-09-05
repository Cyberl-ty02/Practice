package com.tjut.cockpit;

import com.tjut.dao.DBRecord;
import com.tjut.dao.DBUtil;

public class CockpitUtil {
	//获得合同数量
	public static int getContractCount() {
		int count=0;
		try {
			String sql="select * from projectcontract where edition like '%上交版%'";
			count=DBUtil.getRowCount(sql);			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return count;
	}
	//获得合同总及经费
	public static String getFundsSum() {
		String fundstotal="";
		try {
			String sql="select sum(price) as price from projectcontract where edition like '%上交版%'";
			DBRecord record=DBUtil.getDataInfo(sql);
			fundstotal=record.get("price");
		}catch (Exception e) {
			e.printStackTrace();
		}
		return fundstotal;
	}
	//获得承研单位数量
	public static int getDepartCount() {
		int count=0;
		try {
			String sql="select * from unit";
			count=DBUtil.getRowCount(sql);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return count;
	}
	//获得里程碑数量
	public static int getlcbCount() {
		int count=0;
		try {
			String sql="select * from projectcontractlcbinfo where puid in(select uid from projectcontract where edition like '%上交版%')";
			count=DBUtil.getRowCount(sql);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return count;
	}
}
