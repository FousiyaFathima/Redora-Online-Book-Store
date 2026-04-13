<%@ page import="java.sql.*,db.DBConnections" %>
<%@ page contentType="text/html;charset=UTF-8" %>


<%
String email = (String)session.getAttribute("email");

if(email == null){
    response.sendRedirect("login.jsp");
    return;
}

/* 🔥 FIX PARAM NAME */
String book = request.getParameter("bookls");  
int price = Integer.parseInt(request.getParameter("price"));
String image = request.getParameter("image");

Connection con = DBConnections.getConnection();

PreparedStatement ps = con.prepareStatement(
"INSERT INTO wishlist(email,book,price,image) VALUES(?,?,?,?)"
);

ps.setString(1,email);
ps.setString(2,book);
ps.setInt(3,price);
ps.setString(4,image);

ps.executeUpdate();

/* ✅ FIX REDIRECT */
response.sendRedirect("wishlist.jsp");
%>
