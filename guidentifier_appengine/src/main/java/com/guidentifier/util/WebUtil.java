package com.guidentifier.util;

import java.util.List;

import com.guidentifier.dao.DAO;
import com.guidentifier.model.Family;
import com.guidentifier.model.Region;
import com.guidentifier.model.Type;

public class WebUtil {
	public static String encodeForWeb(String str) {
		if (str == null) {
			return "";
		}
		return str.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
	}
	
	private static void showRegionChildren(StringBuffer sb, Region parent, List<Region>allRegions, Region current, String prefix, String postfix) {
		boolean first = true;
		for (Region r: allRegions) {
			if (r.getParent() != null &&  r.getParent().getId() == parent.getId().longValue()) {
				if (first) {
					sb.append("<ul>");
					first = false;
				}
				if (current != null && current.getId() == r.getId().longValue()) {
					sb.append("<li> <b>").append(r.getName()).append("</b>");	
				} else {
					sb.append("<li> <a href=\"/").append(prefix).
						append(r.getId()).append(postfix).append("\">").append(r.getName()).append("</a>");
				}
				showRegionChildren(sb, r, allRegions, current, prefix, postfix);
				sb.append("</li>");
			}
		}
		if (!first) {
			sb.append("</ul>");
		}
	}

	
	public static String showRegions(DAO dao, Region current, String prefix, String postfix) {
		List<Region> allRegions=  dao.getRegionsList();
		StringBuffer sb = new StringBuffer();
		sb.append("<ul>");
		if (current == null) {
			sb.append("<li> <b>All regions</b></li>");
		} else {
			sb.append("<li> <a href=\"/").append(prefix).append("0").append(postfix).append("\">All regions</a></li>");
		}
		for (Region r : allRegions) {
			if (r.getParent() == null) {
				if (current != null && current.getId() == r.getId().longValue()) {
					sb.append("<li> <b>").append(r.getName()).append("</b>");
				} else {
					sb.append("<li> <a href=\"/").append(prefix).
						append(r.getId()).append(postfix).append("\">").append(r.getName()).append("</a>");
				}
				showRegionChildren(sb, r, allRegions, current, prefix, postfix);
				sb.append("</li>");
			}
		}	
		sb.append("</ul>");
		return sb.toString();
	}
	
	static void showFamilyChildren(StringBuffer sb, Family parent, List<Family>allFamilies, Region r, long currentId) {
		boolean first = true;
		for (Family f: allFamilies) {
			if (f.getParent() != null &&  f.getParent().getId() == parent.getId().longValue()) {
				if (first) {
					sb.append("<ul>");
					first = false;
				}
				if (f.getId().longValue() == currentId) {
					sb.append("<li> <b>").append(f.getName()).append("</b>");		
				} else {
					sb.append("<li> <a href=\"/family/").append(r == null ? "0" : r.getId()).append("/").
						append(f.getId()).append("\">").append(f.getName()).append("</a>");
				}
				showFamilyChildren(sb, f, allFamilies, r, currentId);
				sb.append("</li>");
			}
		}
		if (!first) {
			sb.append("</ul>");
		}
	}
	
	public static String showFamilies(DAO dao, Type t, Region r, long currentId) {
		List<Family> allFamilies=  dao.getFamiliesList(t);
		StringBuffer sb = new StringBuffer();
		sb.append("<ul>");
		for (Family f: allFamilies) {
			if (f.getParent() == null) {
				if (f.getId().longValue() == currentId) {
					sb.append("<li> <b>").append(f.getName()).append("</b>");		
				} else {
					sb.append("<li> <a href=\"/family/").append(r == null ? "0" : r.getId()).append("/").
						append(f.getId()).append("\">").append(f.getName()).append("</a>");
				}
				showFamilyChildren(sb, f, allFamilies, r, currentId);
				sb.append("</li>");
			}
		}	
		sb.append("</ul>");
		return sb.toString();
	}
	
}
