<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.*,
				 com.guidentifier.*,
                 com.guidentifier.model.*,
                 com.guidentifier.dao.*,
                 com.guidentifier.util.WebUtil,
                 com.googlecode.objectify.*" %>
<%! 
	boolean isAdmin = true;
	String thisURL = "/family";
	DAO dao = new DAO();
	
	void addFamily(Family parent, String name) {
		Family f = new Family(parent, name);
		dao.add(f);
	}
	
	void addSpecies(Family parent, String name) {
		Species s = new Species(parent, name);
		dao.add(s);
	}
	
	void addFamilyInfo(FamilyInfo fi) {
		dao.add(fi);
	}
%>
<%
	Family family = null;
	FamilyInfo familyInfo = null;
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
	family = dao.getFamily(idStr);
	if (family == null) {
		response.sendRedirect("/familyError/" + idStr);
	}
	familyInfo = dao.getFamilyInfo(family);
	type = family.getType();
	if (familyInfo == null) {
		familyInfo = new FamilyInfo(family);
		addFamilyInfo(familyInfo);
	}

	if (isAdmin && request.getParameter("family.add") != null) {
		addFamily(family, request.getParameter("family.name"));
	}
	if (isAdmin && request.getParameter("species.add") != null) {
		addSpecies(family, request.getParameter("species.name"));
	}
	if (isAdmin && request.getParameter("family.edit") != null) {
		family.setName(request.getParameter("edit.name"));
		dao.add(family);
		familyInfo.setDescription(request.getParameter("edit.description"));
		familyInfo.setImage(request.getParameter("edit.image"));
		familyInfo.setWikipediaURL(request.getParameter("edit.wikipediaURL"));
		dao.add(familyInfo);
	}

%>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Guidentifier: Family - <%= family.getName() %></title>
    <link rel="stylesheet" type="text/css" href="/style/main.css" />
  </head>
   <body>
<div id="title">
	Guidentifier: Family - <%= family.getName() %>
</div>
<div id="breadcrumbs">
	<a href="/<%= region != null ? region.getId() : ""%>">Home</a> > <a href="/type/<%= region == null ? "0" : region.getId() %>/<%= type.getId() %>"><%= type.getName() %></a>
<% 
	List<Family> parents = dao.getParents(family);
	for (Family fiter : parents) {
%>
	> <a href="/family/<%= region == null ? "0" : region.getId() %>/<%= fiter.getId() %>"><%= fiter.getName() %></a>
<%
	}
%>
	> <%= family.getName() %>
</div>
<div id="region">
	<p>Region:</p>
	<%= WebUtil.showRegions(dao, region, "family/", "/" + family.getId()) %>
</div>
<div id="topcontent">
	<div id="guide">
		<h2>Guide - families:</h2>
		<%= WebUtil.showFamilies(dao, type, region, family.getId().longValue()) %>
	</div>
	<div id="species">
		<h2>Species in family:</h2>
		<ul>
<%
	Iterable<Species> species = dao.getSpecies(family);
	for (Species s : species) {
%>
			<li> <a href="/species/<%= region == null ? "0" : region.getId() %>/<%= s.getId()%>" ><%= s.getName()%></a></li>
<%
	}
%>
		</ul>
	</div>
</div>
<div id="info">
	<h2>Info on <%= family.getName() %></h2>
	<p><img src="<%= familyInfo.getImage() %>" align="left"/>
	<%= familyInfo.getDescription() %>
	</p>
	<p><a href="<%= familyInfo.getWikipediaURL() %>">Wikipedia article</a></p>
	<br clear="all"/>
</div>

<%
	if (isAdmin) {
%>
<div id="admin">
	Admin
	<form action="<%= thisURL %>/<%= region == null ? "0" : region.getId() %>/<%= family.getId() %>" method="post">
	<p>Add sub-family:</p>
	<input type="text" name="family.name"/>
	<input type="submit" name="family.add" value="Add"/>
	<br/>
	<p>Add species:</p>
	<input type="text" name="species.name"/>
	<input type="submit" name="species.add" value="Add"/>
	<p>Edit info:</p>
	Family name: <input type="text" name="edit.name" size="50" value="<%= WebUtil.encodeForWeb(family.getName()) %>"/><br/>
	Description: <textarea name="edit.description" cols="100" rows="5"><%= WebUtil.encodeForWeb(familyInfo.getDescription()) %></textarea><br/>
	Image URL: <input type="text" name="edit.image" size="80" value="<%= WebUtil.encodeForWeb(familyInfo.getImage()) %>"/><br/>
	Wikipedia URL: <input type="text" name="edit.wikipediaURL" size="80" value="<%= WebUtil.encodeForWeb(familyInfo.getWikipediaURL()) %>"/><br/>
	<input type="submit" name="family.edit" value="Save"/>
	<input type="reset" value="Reset"/>
	</form>
</div>
<%
	}
%>
  </body>
</html>