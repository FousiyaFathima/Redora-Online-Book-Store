<%@ page import="java.util.*" %>
<%@ page import="java.sql.*,db.DBConnections" %>

<%
int id = Integer.parseInt(request.getParameter("id"));

Connection con = DBConnections.getConnection();

PreparedStatement ps = con.prepareStatement(
"DELETE FROM cart WHERE id=?"
);
ps.setInt(1,id);
ps.executeUpdate();

response.sendRedirect("cart.jsp");
%>