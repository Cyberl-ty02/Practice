package com.tjut.cockpit;

import java.io.IOException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSON;
import com.tjut.dao.DBTable;
import com.tjut.dao.DBUtil;
import com.tjut.util.WebUtil;

@WebServlet("/CockpitService")
public class CockpitService extends HttpServlet {
	private static final long serialVersionUID = 1L;
     
    public CockpitService() {
        super();
    }
    //初始化顶部信息：项目数、经费数
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String result = "";
		String caozuo = WebUtil.getRequestParam(request, "caozuo");
		switch (caozuo) {
			//初始化顶部信息：项目数、经费数
		case "inittopinfo":
			result = gettopinfo(request);
			WebUtil.handleResponse(response, result);
			break;
			//初始化项目信息
		case "initprojectinfo":
			result = getprojectinfo();
			WebUtil.handleResponse(response, result);
			break;	
			//初始化经费拨付信息
		case "initbofu":
			result = getBFInfo();
			WebUtil.handleResponse(response, result);
			break;
			//初始化验收情况
		case "inityanshou":
			result = getYSInfo();
			WebUtil.handleResponse(response, result);
			break;
			//初始化承研单位
		case "initdepart":
			result = getDepartInfo();
			WebUtil.handleResponse(response, result);
			break;
			//初始化里程碑节点
		case "initprojectwcl":
			result = getWCLInfo();
			WebUtil.handleResponse(response, result);
			break;
		
		}
	}
	
	//初始化顶部信息：项目数、经费数
	private String gettopinfo(HttpServletRequest request) {
		String result="";
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			// 合同数量
			int contractcount = CockpitUtil.getContractCount();			
			map.put("contractcount", Integer.toString(contractcount));
			
			// 经费总金额
			String totalfunds = CockpitUtil.getFundsSum();
			map.put("totalfunds", totalfunds);
			
	        // 承研单位数量
			int departcount = CockpitUtil.getDepartCount();
			map.put("departcount", Integer.toString(departcount));
			
			// 里程碑节点数量
			int lcbnodecount = CockpitUtil.getlcbCount();
			map.put("lcbnodecount", Integer.toString(lcbnodecount));
			
			ArrayList<Map<String, Object>> arrayList = new ArrayList<Map<String, Object>>();
			arrayList.add(map);
	
			result = JSON.toJSONString(arrayList);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return result;
	}
	//获得项目信息
	public static String getprojectinfo() {
		String result="";
		try {
			String sql="select  contractno, contractprojectname as projectname,contractunitname as projectunit,price as total,beginenddate as period from projectcontract where edition like '%上交版%'";
			DBTable dt=DBUtil.getDataSetInfo(sql);
			result=JSON.toJSONString(dt);					
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	    return result;
	}
	//验收情况
	public String getYSInfo() {
		ArrayList<Map<String, Object>> arrayList=null;
		try {
			//验收数
			String sql="select distinct projectcode from projectcontract where uid not in(select distinct puid FROM projectcontractlcbinfo where completeflag<>'是' or completeflag is null) and edition like '%上交版%'";
			int count=DBUtil.getRowCount(sql);	
			System.out.println(count);
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("count", count);
			map.put("name", "完成");
			//未验收数
			sql="select distinct projectcode from projectcontract where projectcode not in(select  distinct projectcode from projectcontract where uid not in(select distinct puid FROM projectcontractlcbinfo where completeflag<>'是' or completeflag is null)) and edition like '%上交版%'";
			count=DBUtil.getRowCount(sql);
			Map<String, Object> mapno = new HashMap<String, Object>();
			mapno.put("count", count);
			mapno.put("name", "未完成");
	
			arrayList = new ArrayList<Map<String, Object>>();
			arrayList.add(map);
			arrayList.add(mapno);
		}catch (Exception e) {
			e.printStackTrace();// TODO: handle exception
		}
		return JSON.toJSONString(arrayList);
	}
	//经费拨付
	public String getBFInfo() {
		ArrayList<Map<String, Object>> arrayList=null;
		try {
			//经费数
			String sql="select sum(price) as total from projectcontract where edition like '%上交版%'";
			String total=DBUtil.getFieldInfo(sql, "total");	
			//拨付数
			sql="select sum(value) as bofutotal from projectcontractfundsbofu";
			String bofutotal=DBUtil.getFieldInfo(sql, "bofutotal");	
			double dtotal="".equals(total)?0:Double.parseDouble(total);
			double dbofutotal="".equals(bofutotal)?0:Double.parseDouble(bofutotal);
			double nobofutotal=dtotal-dbofutotal;
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("count", dbofutotal);
			map.put("name", "完成");
			
			Map<String, Object> mapno = new HashMap<String, Object>();
			mapno.put("count", nobofutotal);
			mapno.put("name", "未完成");
	
			arrayList = new ArrayList<Map<String, Object>>();
			arrayList.add(map);
			arrayList.add(mapno);
		}catch (Exception e) {
			e.printStackTrace();
		}

		return JSON.toJSONString(arrayList);
	}
	//集团内或集团外承研单位数
	public String getDepartInfo() {
		ArrayList<Map<String, Object>> arrayList=null;
		try {
			String sql="select * from unit where jituanflag='是'";
			int count=DBUtil.getRowCount(sql);
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("count", count);
			map.put("name", "集团内");
			sql="select * from unit where jituanflag!='是'";
			count=DBUtil.getRowCount(sql);
			Map<String, Object> mapno = new HashMap<String, Object>();
			mapno.put("count", count);
			mapno.put("name", "集团外");
	
			arrayList = new ArrayList<Map<String, Object>>();
			arrayList.add(map);
			arrayList.add(mapno);
		}catch (Exception e) {
			e.printStackTrace();
		}

		return JSON.toJSONString(arrayList);
	}
	
	public String getWCLInfo() {
		ArrayList<Map<String, Object>> arrayList=null;
		try {
			//里程碑节点数
			String sql="select uid from projectcontractlcbinfo where puid in(select uid FROM projectcontract where edition like '%上交版%') and completeflag='是'";
			int count=DBUtil.getRowCount(sql);			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("count", count);
			map.put("name", "完成");
			sql="select uid from projectcontractlcbinfo where puid in(select uid FROM projectcontract where edition like '%上交版%') and (completeflag<>'是' or completeflag is null)";
			count=DBUtil.getRowCount(sql);
			Map<String, Object> mapno = new HashMap<String, Object>();
			mapno.put("count", count);
			mapno.put("name", "未完成");
	
			arrayList = new ArrayList<Map<String, Object>>();
			arrayList.add(map);
			arrayList.add(mapno);
		}catch (Exception e) {
			e.printStackTrace();// TODO: handle exception
		}
		return JSON.toJSONString(arrayList);
	}
	
}
