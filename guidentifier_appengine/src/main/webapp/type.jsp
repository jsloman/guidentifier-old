<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.guidentifier.*,
                 com.guidentifier.model.*,
                 com.guidentifier.dao.*,
                 com.guidentifier.util.WebUtil,
                 com.googlecode.objectify.*,
                 java.util.*" %>
<%! 
	boolean isAdmin = true;
	String thisURL = "/type";
	DAO dao = new DAO();
	
	void addFamily(Type t, String name) {
		Family f = new Family(t, name);
		dao.add(f);
	}
	
	void addForm(Type t, String name) {
		Form f = new Form(t, name);
		dao.add(f);
	}
	

%>
<%
	Region region = null;
	Type type = null;
	if (request.getPathInfo() == null || request.getPathInfo().length() == 1) {
		response.sendRedirect("/");
	}
	String[] parts = request.getPathInfo().split("/");
	if (parts.length != 3) {
		response.sendRedirect("/");
	}
	String regionStr = parts[1];;

	if (!("0".equals(regionStr))) {
		region = dao.getRegion(regionStr);
	}

	String idStr = parts[2];
	type = dao.getType(idStr);
	if (type == null) {
		response.sendRedirect("/typeError/" + idStr);
	}
	
	if (isAdmin && request.getParameter("family.add") != null) {
		addFamily(type, request.getParameter("family.name"));
	}
	if (isAdmin && request.getParameter("form.add") != null) {
		addForm(type, request.getParameter("form.name"));
	}
	if (isAdmin && request.getParameter("type.edit") != null) {
		type.setName(request.getParameter("edit.name"));
		dao.add(type);
	}
%>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Guidentifier: Type - <%= type.getName() %></title>
    <link rel="stylesheet" type="text/css" href="/style/main.css" />    
  </head>
   <body><div id="title">
	Guidentifier: Type - <%= type.getName() %>
</div>
<div id="breadcrumbs">
	<a href="/<%= region != null ? region.getId() : ""%>">Home</a> > <%= type.getName() %>
</div>
<div id="region">
	<p>Region:</p>
	<%= WebUtil.showRegions(dao, region, "type/", "/" + type.getId()) %>
</div>
<div id="topcontent">
	<div id="guide">
		<h2>Guide - families:</h2>
		<%= WebUtil.showFamilies(dao, type, region, -1) %>
	</div>
	<div id="identifier">
		<h2>Identifier - form to identify:</h2>
		<ul>
<%
	Iterable<Form> forms = dao.getForms(type);
	for (Form f : forms) {
%>
			<li> <a href="/form/<%= f.getId()%>" %><%= f.getName()%></a></li>
<%
	}
%>
		</ul>
	</div>
</div>
<%
	if (isAdmin) {
%>
<div id="admin">
	Admin
	<form action="<%= thisURL %>/<%= region == null ? "0" : region.getId() %>/<%= type.getId() %>" method="post">
	<p>Add family:</p>
	<input type="text" name="family.name"/>
	<input type="submit" name="family.add" value="Add"/>
	<br/>
	<p>Add form:</p>
	<input type="text" name="form.name"/>
	<input type="submit" name="form.add" value="Add"/>
	<br/>
	<p>Edit type:</p>
	Type Name: <input type="text" name="edit.name" size="50" value="<%= WebUtil.encodeForWeb(type.getName()) %>"/><br/>
	<input type="submit" name="type.edit" value="Save"/>
	<input type="reset" value="Reset"/>
	</form>
</div>
<%
	}
%>
  </body>
</html>