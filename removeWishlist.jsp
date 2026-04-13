<%@ page import="java.sql.*,db.DBConnections" %>

<%
int id = Integer.parseInt(request.getParameter("id"));

Connection con = DBConnections.getConnection();

PreparedStatement ps = con.prepareStatement(
"DELETE FROM wishlist WHERE id=?"
);
ps.setInt(1,id);
ps.executeUpdate();

response.sendRedirect("wishlist.jsp");
%>