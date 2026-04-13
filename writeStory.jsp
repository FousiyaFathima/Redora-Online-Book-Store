<%-- 
    Document   : writeStory
    Created on : 28 Mar, 2026, 11:10:29 AM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String email = (String)session.getAttribute("email");
if(email == null){ response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Write Your Story</title>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;600;700&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
    <style>
        /* Aesthetic Variables */
        :root { --primary-bg: #F9F7F2; --text-dark: #2C2C2C; --accent-wine: #722F37; --accent-gold: #C5A059; }
        body { font-family: 'Lato', sans-serif; background-color: var(--primary-bg); background-image: url('https://www.transparenttextures.com/patterns/cream-paper.png'); color: var(--text-dark); display: flex; justify-content: center; padding-top: 100px; }
        .container { background: white; padding: 50px; border-radius: 10px; box-shadow: 0 15px 40px rgba(0,0,0,0.1); width: 600px; border: 1px solid rgba(197, 160, 89, 0.2); }
        h2 { font-family: 'Cormorant Garamond', serif; font-size: 36px; color: var(--accent-wine); text-align: center; margin-bottom: 30px; }
        input, textarea { width: 100%; padding: 15px; margin: 10px 0 20px 0; border: 1px solid #ddd; border-radius: 6px; font-family: 'Lato', sans-serif; font-size: 16px; box-sizing: border-box; }
        textarea { height: 250px; resize: vertical; }
        input:focus, textarea:focus { outline: none; border-color: var(--accent-gold); }
        button { width: 100%; padding: 15px; background: var(--accent-wine); color: white; border: none; border-radius: 30px; font-size: 16px; font-weight: 600; cursor: pointer; transition: 0.3s; }
        button:hover { background: #5a2429; }
        .back-link { display: block; text-align: center; margin-top: 20px; color: var(--accent-wine); text-decoration: none; }
    </style>
</head>
<body>

<div class="container">
    <h2>Pen Your Tale ✒️</h2>
    <p style="text-align:center; margin-bottom:20px;">Share your story with the world. The best story wins a free book!</p>
    
    <form action="saveStory.jsp" method="post">
        <label>Title of your Story</label>
        <input type="text" name="title" placeholder="Once upon a time..." required>
        
        <label>Your Story</label>
        <textarea name="content" placeholder="Write your heart out..." required></textarea>
        
        <button type="submit">Submit Story</button>
    </form>
    <a href="storyWall.jsp" class="back-link">← Back to Story Wall</a>
</div>

</body>
</html>