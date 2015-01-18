<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List,
 				 com.guidentifier.*,
                 com.guidentifier.model.*,
                 com.guidentifier.dao.*,
                 com.guidentifier.util.WebUtil,
                 com.googlecode.objectify.*" %>
<%! 
	boolean isAdmin = true;
	String thisURL = "/";
	DAO dao = new DAO();
		
	void addType(String name) {
		Type t = new Type(name);
		dao.add(t);
	}
	
	void addRegion(Region parent, String name) {
		Region r;
		if (parent == null) {
			r = new Region(name);
		} else {
			r = new Region(parent, name);
		}
		dao.add(r);
		System.err.println("Added region: " + name);
	}

%>
<%
	Region region = null;
	if (request.getPathInfo() != null && request.getPathInfo().length() > 1) {
		String idStr = request.getPathInfo().substring(1);
		if (!"0".equals(idStr)) {
			region= dao.getRegion(idStr);
		}
	}
	
	if (isAdmin && request.getParameter("type.add") != null) {
		addType(request.getParameter("type.name"));
	}
	if (isAdmin && request.getParameter("region.add") != null) {
		addRegion(region, request.getParameter("region.name"));
	}
	if (isAdmin && request.getParameter("region.edit") != null && region != null) {
		region.setName(request.getParameter("region.editname"));
		dao.add(region);
	}
%>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Guidentifier</title>
    <link rel="stylesheet" type="text/css" href="/style/main.css" />
  </head>
   <body>
<div id="title">
	Guidentifier
</div>
<div id="breadcrumbs">
Home
</div>
<div id="region">
	<p>Region:</p>
	<%= WebUtil.showRegions(dao, region, "", "") %>
</div>
<div id="type">
	<p>Choose what kind of thing you want to Guidentify:</p>
	<ul>
<%
	Iterable<Type> types = dao.getTypes();
	for (Type t : types) {
%>
		<li> <a href="type/<%= region == null ? "0" : region.getId() %>/<%= t.getId()%>" %><%= t.getName()%></a></li>
<%
	}
%>
	</ul>
</div>
<%
	if (isAdmin) {
%>
<div id="admin">
	Admin
	<form action="<%= thisURL %><%= region != null ? region.getId() : "" %>" method="post">
	<p>Add type:</p>

	<input type="text" size="50" name="type.name"/>
	<input type="submit" name="type.add" value="Add"/>
	<br/>
	<p>Add region:</p>
	<input type="text" size="50" name="region.name"/>
	<input type="submit" name="region.add" value="Add"/>
<%
		if (region != null) {
%>
	<p>Edit region:</p>
	<input type="text" size="50" name="region.editname" value="<%= WebUtil.encodeForWeb(region.getName()) %>"/><br/>
	<input type="submit" name="region.edit" value="Save"/>
	<input type="reset" value="Reset"/>
<%
		}
%>
	</form>
</div>
<%
	}
%>
  </body>
</html>