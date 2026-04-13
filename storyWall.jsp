<%@ page import="java.sql.*, db.DBConnections" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
String email = (String)session.getAttribute("email");
if(email == null){ response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Story Wall</title>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;600;700&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <style>
        :root { --primary-bg: #F9F7F2; --text-dark: #2C2C2C; --accent-wine: #722F37; --accent-gold: #C5A059; }
        body { font-family: 'Lato', sans-serif; background-color: var(--primary-bg); background-image: url('https://www.transparenttextures.com/patterns/cream-paper.png'); color: var(--text-dark); margin: 0; padding: 0; }
        
        .navbar { display: flex; justify-content: space-between; align-items: center; background: rgba(255, 255, 255, 0.95); padding: 20px 60px; border-bottom: 1px solid rgba(197, 160, 89, 0.3); position: fixed; width: 100%; top: 0; z-index: 1000; }
        .logo { font-family: 'Cormorant Garamond', serif; font-size: 28px; color: var(--accent-wine); text-decoration: none; font-weight: 700; }
        .nav-links a { color: var(--text-dark); margin-left: 30px; text-decoration: none; font-size: 13px; text-transform: uppercase; letter-spacing: 1px; }
        
        .main-container { max-width: 800px; margin: 120px auto 50px auto; padding: 0 20px; }
        .header { text-align: center; margin-bottom: 50px; }
        .header h1 { font-family: 'Cormorant Garamond', serif; font-size: 42px; color: var(--accent-wine); margin: 0; }
        
        /* Breadcrumb */
        .breadcrumb { margin-bottom: 30px; font-size: 14px; color: #666; }
        .breadcrumb a { color: var(--accent-wine); text-decoration: none; }

        .story-card { background: white; padding: 30px; border-radius: 8px; margin-bottom: 40px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); border: 1px solid rgba(197, 160, 89, 0.2); position: relative; }
        .story-card.winner { border: 2px solid var(--accent-gold); box-shadow: 0 0 20px rgba(197, 160, 89, 0.3); }
        
        .winner-badge { position: absolute; top: -15px; right: 20px; background: var(--accent-gold); color: #000; padding: 5px 15px; border-radius: 20px; font-weight: 700; font-size: 12px; text-transform: uppercase; }
        
        .story-title { font-family: 'Cormorant Garamond', serif; font-size: 28px; color: var(--text-dark); margin-bottom: 10px; }
        .story-meta { font-size: 12px; color: #888; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        .story-content { font-size: 16px; line-height: 1.8; color: #444; white-space: pre-wrap; margin-bottom: 25px; }
        
        /* Action Bar (Like & Comments) */
        .action-bar { display: flex; align-items: center; gap: 20px; margin-bottom: 20px; padding-top: 10px; border-top: 1px solid #eee; }
        
        .like-btn { display: flex; align-items: center; gap: 5px; color: #888; text-decoration: none; font-size: 14px; padding: 5px 10px; border-radius: 4px; transition: 0.3s; }
        .like-btn:hover { background: #f0f0f0; color: var(--accent-wine); }
        .like-btn.liked { color: #D32F2F; font-weight: bold; }
        .like-btn i { font-size: 18px; }
        
        .comment-section { background: #f9f9f9; padding: 15px; border-radius: 5px; }
        .comment-item { margin-bottom: 10px; padding-bottom: 10px; border-bottom: 1px dashed #ddd; }
        .comment-item:last-child { border-bottom: none; }
        .comment-author { font-weight: 700; font-size: 12px; color: var(--accent-wine); }
        .comment-text { font-size: 14px; color: #555; margin-top: 5px; }
        
        form textarea { width: 100%; border: 1px solid #ddd; padding: 10px; font-family: 'Lato', sans-serif; border-radius: 4px; margin-bottom: 10px; height: 60px; resize: none; }
        form button { background: var(--text-dark); color: white; border: none; padding: 8px 20px; border-radius: 20px; cursor: pointer; font-size: 12px; }
    </style>
</head>
<body>

<div class="navbar">
    <a href="index.jsp" class="logo">READORA</a>
    <div class="nav-links">
        <a href="storyWall.jsp">Story Wall</a>
        <a href="writeStory.jsp">Write Story</a>
        <a href="profile.jsp">Profile</a>
    </div>
</div>

<div class="main-container">
    <!-- Breadcrumbs -->
    <div class="breadcrumb">
        <a href="index.jsp">Home</a> / <span style="color:#999;">Story Wall</span>
        <a href="collection.jsp" style="float:right; background:#fff; padding:8px 20px; border-radius:20px; text-decoration:none; color:var(--text-dark); border:1px solid #ddd;">Continue Shopping</a>
        <div style="clear:both;"></div>
    </div>

    <div class="header">
        <h1>Story Wall</h1>
        <p>Read amazing stories from our community.</p>
    </div>

<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    con = DBConnections.getConnection();
    // LOGIC: Order by is_winner DESC puts winners (1) before non-winners (0)
    String sql = "SELECT * FROM stories ORDER BY is_winner DESC, date DESC";
    ps = con.prepareStatement(sql);
    rs = ps.executeQuery();
    
    while(rs.next()){
        int storyId = rs.getInt("id");
        String authorEmail = rs.getString("email");
        String title = rs.getString("title");
        String content = rs.getString("content");
        String date = rs.getString("date");
        boolean isWinner = rs.getInt("is_winner") == 1;
        
        // --- LIKE COUNT LOGIC ---
        int likeCount = 0;
        boolean isLiked = false;
        
        // Get Like Count
        PreparedStatement psLike = con.prepareStatement("SELECT COUNT(*) FROM story_likes WHERE story_id=?");
        psLike.setInt(1, storyId);
        ResultSet rsLike = psLike.executeQuery();
        if(rsLike.next()) likeCount = rsLike.getInt(1);
        rsLike.close(); psLike.close();
        
        // Check if Current User Liked
        PreparedStatement psCheck = con.prepareStatement("SELECT * FROM story_likes WHERE story_id=? AND email=?");
        psCheck.setInt(1, storyId);
        psCheck.setString(2, email);
        ResultSet rsCheck = psCheck.executeQuery();
        if(rsCheck.next()) isLiked = true;
        rsCheck.close(); psCheck.close();
        // ------------------------
%>

    <div class="story-card <%= isWinner ? "winner" : "" %>">
        <% if(isWinner) { %> <span class="winner-badge">🏆 Winner</span> <% } %>
        
        <h3 class="story-title"><%= title %></h3>
        <div class="story-meta">By: <%= authorEmail %> | <%= date %></div>
        <div class="story-content"><%= content %></div>
        
        <!-- Action Bar -->
        <div class="action-bar">
            <!-- Like Button -->
            <a href="likeStory.jsp?id=<%= storyId %>" class="like-btn <%= isLiked ? "liked" : "" %>">
                <% if(isLiked) { %>
                    <i class="fa fa-heart"></i>
                <% } else { %>
                    <i class="fa fa-heart-o"></i>
                <% } %>
                <span><%= likeCount %> Likes</span>
            </a>
        </div>
        
        <!-- Comments Section -->
        <div class="comment-section">
            <h4 style="margin-top:0; color:#555;">Comments</h4>
            <%
            PreparedStatement ps2 = null;
            ResultSet rs2 = null;
            try {
                ps2 = con.prepareStatement("SELECT * FROM story_comments WHERE story_id=? ORDER BY date DESC");
                ps2.setInt(1, storyId);
                rs2 = ps2.executeQuery();
                
                while(rs2.next()){
            %>
                    <div class="comment-item">
                        <div class="comment-author"><%= rs2.getString("email") %></div>
                        <div class="comment-text"><%= rs2.getString("comment") %></div>
                    </div>
            <%
                }
            } finally {
                if(rs2 != null) rs2.close();
                if(ps2 != null) ps2.close();
            }
            %>
            
            <form action="postComment.jsp" method="post">
                <input type="hidden" name="story_id" value="<%= storyId %>">
                <textarea name="comment" placeholder="Write a comment..." required></textarea>
                <button type="submit">Post Comment</button>
            </form>
        </div>
    </div>

<%
    }
} catch(Exception e) {
    out.println("Error: " + e.getMessage());
} finally {
    if(rs != null) rs.close();
    if(ps != null) ps.close();
    if(con != null) con.close();
}
%>

</div>

</body>
</html>