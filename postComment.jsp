<%-- 
    Document   : postComment
    Created on : 28 Mar, 2026, 11:12:30 AM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, db.DBConnections" %>
<%
String email = (String)session.getAttribute("email");
if(email == null){ response.sendRedirect("login.jsp"); return; }

String storyId = request.getParameter("story_id");
String comment = request.getParameter("comment");

if(storyId != null && comment != null){
    Connection con = null;
    PreparedStatement ps = null;
    try {
        con = DBConnections.getConnection();
        String sql = "INSERT INTO story_comments(story_id, email, comment) VALUES(?,?,?)";
        ps = con.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(storyId));
        ps.setString(2, email);
        ps.setString(3, comment);
        ps.executeUpdate();
    } catch(Exception e) { e.printStackTrace(); }
    finally { if(ps!=null) ps.close(); if(con!=null) con.close(); }
}
response.sendRedirect("storyWall.jsp");
%>