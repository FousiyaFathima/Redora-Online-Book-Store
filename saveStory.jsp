<%-- 
    Document   : saveStory
    Created on : 28 Mar, 2026, 11:11:00 AM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, db.DBConnections" %>
<%
String email = (String)session.getAttribute("email");
if(email == null){ response.sendRedirect("login.jsp"); return; }

String title = request.getParameter("title");
String content = request.getParameter("content");

if(title != null && content != null){
    Connection con = null;
    PreparedStatement ps = null;
    try {
        con = DBConnections.getConnection();
        String sql = "INSERT INTO stories(email, title, content) VALUES(?,?,?)";
        ps = con.prepareStatement(sql);
        ps.setString(1, email);
        ps.setString(2, title);
        ps.setString(3, content);
        ps.executeUpdate();
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(ps != null) ps.close();
        if(con != null) con.close();
    }
}
response.sendRedirect("storyWall.jsp");
%>