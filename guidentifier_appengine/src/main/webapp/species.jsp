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
	String thisURL = "/species";
	DAO dao = new DAO();
	
	void addSpeciesInfo(SpeciesInfo si) {
		dao.add(si);
	}
%>
<%
	Species species = null;
	SpeciesInfo speciesInfo = null;
	Type type = null;
	Family family = null;
	Region region = null;

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
	species = dao.getSpecies(idStr);
	if (species == null) {
		response.sendRedirect("/speciesError/" + idStr);
	}
	speciesInfo = dao.getSpeciesInfo(species);
	type = species.getType();
	family = species.getFamily();
	if (speciesInfo == null) {
		speciesInfo = new SpeciesInfo(species);
		addSpeciesInfo(speciesInfo);
	}

	if (isAdmin && request.getParameter("species.edit") != null) {
		species.setName(request.getParameter("edit.name"));
		dao.add(species);
		speciesInfo.setDescription(request.getParameter("edit.description"));
		speciesInfo.setImage(request.getParameter("edit.image"));
		speciesInfo.setWikipediaURL(request.getParameter("edit.wikipediaURL"));
		dao.add(speciesInfo);
	}

%>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Guidentifier: Species - <%= species.getName() %></title>
    <link rel="stylesheet" type="text/css" href="/style/main.css" />
  </head>
   <body>
<div id="title">
	Guidentifier: Species - <%= species.getName() %>
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
	> <a href="/family/<%= region == null ? "0" : region.getId() %>/<%= family.getId() %>"><%= family.getName() %></a>
	> <%= species.getName() %>
</div>
<div id="info">
	Info on <%= species.getName() %>
	<p><img src="<%= speciesInfo.getImage() %>" align="left"/>
	<%= speciesInfo.getDescription() %>
	</p>
	<p><a href="<%= speciesInfo.getWikipediaURL() %>">Wikipedia article</a></p>
	<br clear="all"/>
</div>

<%
	if (isAdmin) {
%>
<div id="admin">
	Admin
	<form action="<%= thisURL %>/<%= region == null ? "0" : region.getId() %>/<%= species.getId() %>" method="post">
	<p>Edit info:</p>
	Species name: <input type="text" name="edit.name" size="50" value="<%= WebUtil.encodeForWeb(species.getName()) %>"/><br/>
	Description: <textarea name="edit.description" rows="5" cols="100"><%= WebUtil.encodeForWeb(speciesInfo.getDescription()) %></textarea><br/>
	Image URL: <input type="text" name="edit.image" size="80" value="<%= WebUtil.encodeForWeb(speciesInfo.getImage()) %>"/><br/>
	Wikipedia URL: <input type="text" name="edit.wikipediaURL" size="80" value="<%= WebUtil.encodeForWeb(speciesInfo.getWikipediaURL()) %>"/><br/>
	<input type="submit" name="species.edit" value="Save"/>
	<input type="reset" value="Reset"/>
	</form>
</div>
<%
	}
%>
  </body>
</html>