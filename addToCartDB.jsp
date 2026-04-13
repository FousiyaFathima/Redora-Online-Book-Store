<%@page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.sql.*, db.DBConnections" %>
<%@ page import="java.sql.*, db.DBConnections" %>
<%
String email = (String)session.getAttribute("email");
if(email == null){
    response.sendRedirect("login.jsp");
    return;
}

String book = request.getParameter("bookls");
String priceStr = request.getParameter("price");
String image = request.getParameter("image");
String qtyStr = request.getParameter("qty");

int price = 0;
int qty = 1;

try { price = Integer.parseInt(priceStr); } catch(Exception e){}
try { qty = Integer.parseInt(qtyStr); } catch(Exception e){}

Connection con = null;
PreparedStatement ps = null;

try {
    con = DBConnections.getConnection();

    // 1️⃣ Check if book exists
    String checkSql = "SELECT qty FROM cart WHERE email=? AND book=?";
    ps = con.prepareStatement(checkSql);
    ps.setString(1,email);
    ps.setString(2,book);
    ResultSet rs = ps.executeQuery();

    if(rs.next()){
        // Book exists → increase quantity by qty from category page
        int existingQty = rs.getInt("qty");
        ps.close();
        String updateSql = "UPDATE cart SET qty=? WHERE email=? AND book=?";
        ps = con.prepareStatement(updateSql);
        ps.setInt(1, existingQty + qty);
        ps.setString(2,email);
        ps.setString(3,book);
        ps.executeUpdate();
        ps.close();
    } else {
        // Book not in cart → insert new
        ps.close();
        String insertSql = "INSERT INTO cart(email, book, price, image, qty) VALUES(?,?,?,?,?)";
        ps = con.prepareStatement(insertSql);
        ps.setString(1,email);
        ps.setString(2,book);
        ps.setInt(3,price);
        ps.setString(4,image);
        ps.setInt(5,qty);
        ps.executeUpdate();
        ps.close();
    }

    rs.close();
} catch(Exception e){
    e.printStackTrace();
} finally {
    try{ if(ps!=null) ps.close(); } catch(Exception e){}
    try{ if(con!=null) con.close(); } catch(Exception e){}
}

// 🔹 Redirect to cart page directly
response.sendRedirect("cart.jsp");
%>