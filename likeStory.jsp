<%-- 
    Document   : likeStory
    Created on : 28 Mar, 2026, 11:46:27 AM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, db.DBConnections" %>
<%
String email = (String)session.getAttribute("email");
String storyIdStr = request.getParameter("id");

if(email != null && storyIdStr != null){
    int storyId = Integer.parseInt(storyIdStr);
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnections.getConnection();
        
        // 1. Check if user already liked this story
        String checkSql = "SELECT * FROM story_likes WHERE story_id=? AND email=?";
        ps = con.prepareStatement(checkSql);
        ps.setInt(1, storyId);
        ps.setString(2, email);
        rs = ps.executeQuery();
        
        if(rs.next()){
            // 2a. Already liked -> UNLIKE (Delete)
            ps.close();
            String deleteSql = "DELETE FROM story_likes WHERE story_id=? AND email=?";
            ps = con.prepareStatement(deleteSql);
            ps.setInt(1, storyId);
            ps.setString(2, email);
            ps.executeUpdate();
        } else {
            // 2b. Not liked -> LIKE (Insert)
            ps.close();
            String insertSql = "INSERT INTO story_likes(story_id, email) VALUES(?,?)";
            ps = con.prepareStatement(insertSql);
            ps.setInt(1, storyId);
            ps.setString(2, email);
            ps.executeUpdate();
        }
        
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(rs != null) rs.close();
        if(ps != null) ps.close();
        if(con != null) con.close();
    }
}
response.sendRedirect("storyWall.jsp");
%>