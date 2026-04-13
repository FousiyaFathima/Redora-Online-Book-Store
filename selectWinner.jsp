<%@ page import="java.sql.*, db.DBConnections" %>
<%
// 1. Check if Admin is logged in
if(session.getAttribute("admin") == null){
    response.sendRedirect("login.jsp");
    return;
}

// 2. Get the Story ID from the URL
String idStr = request.getParameter("id");
if(idStr != null) {
    Connection con = null;
    PreparedStatement ps = null;
    
    try {
        int storyId = Integer.parseInt(idStr);
        con = DBConnections.getConnection();
        
        // 3. Update the database: Set is_winner = 1 for the selected story
        // Note: If you want only ONE winner at a time, uncomment the next 3 lines to reset others first.
        /*
        PreparedStatement resetPs = con.prepareStatement("UPDATE stories SET is_winner = 0");
        resetPs.executeUpdate();
        resetPs.close();
        */
        
        String sql = "UPDATE stories SET is_winner = 1 WHERE id = ?";
        ps = con.prepareStatement(sql);
        ps.setInt(1, storyId);
        
        int i = ps.executeUpdate();
        
        if(i > 0) {
            // Success
            response.sendRedirect("adminStory.jsp");
        } else {
            out.println("Failed to update winner status.");
        }
        
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if(ps != null) ps.close();
        if(con != null) con.close();
    }
} else {
    response.sendRedirect("adminStory.jsp");
}
%>