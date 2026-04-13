<%@ page import="java.sql.*, db.DBConnections" %>
<%
    String email = (String) session.getAttribute("email");
    if(email == null){
        response.sendRedirect("login.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    String action = request.getParameter("action");

    if(idStr != null && action != null){
        int id = Integer.parseInt(idStr);
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnections.getConnection();

            if(action.equals("inc")){
                ps = con.prepareStatement("UPDATE cart SET qty = qty + 1 WHERE id = ?");
                ps.setInt(1, id);
                ps.executeUpdate();
                ps.close();
            } else if(action.equals("dec")){
                ps = con.prepareStatement("SELECT qty FROM cart WHERE id = ?");
                ps.setInt(1, id);
                rs = ps.executeQuery();
                if(rs.next()){
                    int qty = rs.getInt("qty");
                    ps.close();
                    if(qty > 1){
                        ps = con.prepareStatement("UPDATE cart SET qty = qty - 1 WHERE id = ?");
                        ps.setInt(1, id);
                        ps.executeUpdate();
                        ps.close();
                    } else {
                        ps = con.prepareStatement("DELETE FROM cart WHERE id = ?");
                        ps.setInt(1, id);
                        ps.executeUpdate();
                        ps.close();
                    }
                }
                if(rs != null) rs.close();
            }

        } catch(Exception e){ e.printStackTrace(); }
        finally {
            try{ if(ps!=null) ps.close(); }catch(Exception e){}
            try{ if(con!=null) con.close(); }catch(Exception e){}
        }
    }

    // Redirect back to cart page
    response.sendRedirect("cart.jsp");
%>