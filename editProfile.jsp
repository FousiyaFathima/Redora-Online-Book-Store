<%-- 
    Document   : editProfile
    Created on : 19 Mar, 2026, 4:59:55 PM
    Author     : acer
--%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.sql.*,db.DBConnections" %>

<%
String email = (String)session.getAttribute("email");

if(request.getParameter("update") != null){

String name = request.getParameter("name");
String phone = request.getParameter("phone");
String address = request.getParameter("address");

Connection con = DBConnections.getConnection();

PreparedStatement ps = con.prepareStatement(
"UPDATE users SET name=?, phone=?, address=? WHERE email=?"
);

ps.setString(1,name);
ps.setString(2,phone);
ps.setString(3,address);
ps.setString(4,email);

ps.executeUpdate();

/* UPDATE SESSION */
session.setAttribute("name", name);
session.setAttribute("phone", phone);
session.setAttribute("address", address);

response.sendRedirect("profile.jsp");
}
%>

<form method="post">
<input name="name" placeholder="Name"><br>
<input name="phone" placeholder="Phone"><br>
<textarea name="address" placeholder="Address"></textarea><br>

<button name="update">Update</button>
</form>

