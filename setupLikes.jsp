<%-- 
    Document   : setupLikes
    Created on : 28 Mar, 2026, 11:45:13 AM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, db.DBConnections" %>
<html>
<body>
<h2>Creating Likes Table...</h2>
<%
try {
    Connection con = DBConnections.getConnection();
    Statement stmt = con.createStatement();
    
    // Table to store who liked which story
    String sql = "CREATE TABLE story_likes (" +
                 "id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1), " +
                 "story_id INT, " +
                 "email VARCHAR(100))";
    
    stmt.executeUpdate(sql);
    out.println("<p style='color:green'>Table 'story_likes' created!</p>");
    
    stmt.close();
    con.close();
} catch(Exception e) {
    if(e.getMessage().contains("already exists")) {
        out.println("<p style='color:orange'>Table already exists.</p>");
    } else {
        out.println("<p style='color:red'>Error: " + e.getMessage() + "</p>");
    }
}
%>
</body>
</html>