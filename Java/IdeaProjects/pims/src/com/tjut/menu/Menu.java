package com.tjut.menu;
import java.util.List;

public class Menu {
    private String id;
    private String text;
    private String iconCls;
    private List<Menu> children;
    private String pid;
    private String url;
    private String state;
    
    public Menu(String menuid, String pid,String menuname,String url,String icon) {		
		this.id = menuid;
		this.text = menuname;
		this.iconCls = icon;
		this.pid = pid;
		this.url=url;
	}
    
    public Menu(String menuid, String pid,String menuname,String url,String icon,String state) {		
		this.id = menuid;
		this.text = menuname;
		this.iconCls = icon;
		this.pid = pid;
		this.url=url;
		this.state=state;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	

	public String getIconCls() {
		return iconCls;
	}

	public void setIconCls(String iconCls) {
		this.iconCls = iconCls;
	}

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public List<Menu> getChildren() {
		return children;
	}

	public void setChildren(List<Menu> children) {
		this.children = children;
	}
	
}
