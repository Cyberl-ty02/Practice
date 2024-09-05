package com.tjut.util;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;

public class Common {

	// 获得当前系统的日期及星期几信息，如：2017年1月16日 星期一
	public static String getDate() {
		String temp = "";
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat(" yyyy年MM月dd日 E ");
		temp = sdf.format(date);
		return temp;
	}

	// 根据格式化串返回响应日期的字符串
	// yy-MM-dd:日期
	// HH:mm:ss:时间
	public static String getDate(String format) {
		String temp = "";
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		temp = sdf.format(date);
		return temp;
	}

	// 获得当前的月份
	public static int getMonth() {
		Calendar now = Calendar.getInstance();
		return now.get(Calendar.MONTH) + 1;
	}

	// 获得当前日期的前month月日期，日期为当月1号开始
	public static String getBeforeDate(int month) throws ParseException {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.MONTH, month);
		int year = calendar.get(Calendar.YEAR);
		int tempmonth = calendar.get(Calendar.MONTH) + 1;
		String temp = year + "-" + tempmonth + "-01";
		return sdf.format(sdf.parse(temp));
	}

	// 获得参数：date日期之后的日期,monthandday:月或天；type:按天或月计算
	public static String getAfterDate(String date, int monthandday, String type) throws ParseException {
		String result = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date d = sdf.parse(date);
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(d);
		switch (type) {
		case "月":
			calendar.add(Calendar.MONTH, monthandday);
			int year = calendar.get(Calendar.YEAR);
			int tempmonth = calendar.get(Calendar.MONTH) + 1;
			int day = calendar.get(Calendar.DAY_OF_MONTH);
			String temp = year + "-" + tempmonth + "-" + day;
			result = sdf.format(sdf.parse(temp));
			break;
		case "天":
			calendar.add(Calendar.DAY_OF_MONTH, monthandday);
			year = calendar.get(Calendar.YEAR);
			tempmonth = calendar.get(Calendar.MONTH) + 1;
			day = calendar.get(Calendar.DAY_OF_MONTH);
			temp = year + "-" + tempmonth + "-" + day;
			result = sdf.format(sdf.parse(temp));
			break;
		}
		return result;
	}

	// 获得上传附件保存的路径
	public static String getFilePath() throws IOException {
		InputStream in = Common.class.getClassLoader().getResourceAsStream("path.properties");
		Properties pro = new Properties();
		pro.load(in);
		String path = pro.getProperty("path.absolutepath");
		return path.replace("&", File.separator);
	}

	public static void main(String a[]) throws ParseException {
		// System.out.println(Common.getAfterDate("2018-11-21", 15, "天"));
		// String[] str1 = { "2019-05-07", "2019-05-06", "2018-05-08", "2019-05-14" };
		// String[] str2 = { "2022-01-01", "2022-01-02", "2022-01-03", "2022-01-04" };
		// for (int i = 0; i < str1.length; i++) {
		// System.out.println(differentDaysByDate(new Date(), parseDate(str2[i])));
		// }
		

	}


}