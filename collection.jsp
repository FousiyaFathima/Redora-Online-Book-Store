<%@page import="java.util.ArrayList"%>
<%@ page import="java.sql.*,db.DBConnections" %>

<%
String email_nav = (String)session.getAttribute("email");
int count = 0;

if(email_nav != null){
    Connection con_nav = DBConnections.getConnection();
    PreparedStatement ps_nav = con_nav.prepareStatement(
        "SELECT SUM(qty) FROM cart WHERE email=?"
    );
    ps_nav.setString(1, email_nav);
    ResultSet rs_nav = ps_nav.executeQuery();

    if(rs_nav.next()){
        count = rs_nav.getInt(1);
    }
}
%>
<%
String email = (String)session.getAttribute("email");

if(email == null){
    response.sendRedirect("login.jsp");
    return;
}
%>
<%
String search = request.getParameter("search");
%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Book Collection</title>

<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;0,700;1,400&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">

<style>
/* --- AESTHETIC VARIABLES --- */
:root {
    --primary-bg: #F9F7F2;
    --text-dark: #2C2C2C;
    --accent-wine: #722F37;
    --accent-gold: #C5A059;
    --neon-gold: #F4D03F;    /* Brighter Gold for Neon */
    --neon-wine: #9b3d47;    /* Brighter Wine for Neon */
}

* { margin: 0; padding: 0; box-sizing: border-box; }

body{
    font-family: 'Lato', sans-serif;
    color: var(--text-dark);
    background-color: var(--primary-bg);
    background-image: url('https://www.transparenttextures.com/patterns/cream-paper.png');
    position: relative;
}

/* --- NAVBAR --- */
.navbar{
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    padding: 20px 80px;
    border-bottom: 1px solid rgba(197, 160, 89, 0.3);
    position: fixed;
    width: 100%;
    top: 0;
    z-index: 1000;
    box-shadow: 0 4px 20px rgba(0,0,0,0.05);
}

h1 {
    font-family: 'Cormorant Garamond', serif;
    font-size: 28px;
    color: var(--accent-wine);
    letter-spacing: 1px;
    font-weight: 600;
}

.nav-links a{
    color: var(--text-dark);
    margin-left: 35px;
    text-decoration: none;
    font-size: 13px;
    text-transform: uppercase;
    letter-spacing: 1.5px;
    transition: color 0.3s;
}

.nav-links a:hover { color: var(--accent-wine); }

.cart-icon{ position: relative; cursor: pointer; }
.cart-count{
    position: absolute;
    top: -8px; right: -10px;
    background: var(--accent-wine);
    color: white;
    border-radius: 50%;
    padding: 2px 6px;
    font-size: 10px;
}

/* --- CONTAINER WRAPPER --- */
.main-content {
    margin-top:100px; /* Space for fixed navbar */
    padding-bottom:10px;
    
}

/* --- SEARCH BAR --- */

input[type="text"] {
    padding: 14px 25px;
    width: 400px;
    border: 1px solid #ddd;
    border-radius: 30px;
    background: white;
    font-size: 14px;
    transition: 0.3s;
}

input[type="text"]:focus {
    outline: none;
    border-color: var(--accent-gold);
    box-shadow: 0 0 10px rgba(197, 160, 89, 0.2);
}

button {
    padding: 14px 30px;
    background: var(--accent-wine);
    color: white;
    border: none;
    border-radius: 30px;
    margin-left: 10px;
    cursor: pointer;
    font-weight: 600;
    transition: background 0.3s;
}

button:hover { background: #5a2429; }

/* --- ANNOUNCEMENT STRIP --- */
.announcement-strip {
    background: linear-gradient(90deg, #fff, #fff);
    border: 1px solid var(--accent-gold);
    border-radius: 50px;
    padding: 15px 30px;
    margin: 0 auto 50px auto;
    max-width: 800px;
    text-align: center;
    box-shadow: 0 5px 15px rgba(0,0,0,0.05);
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 15px;
    animation: fadeIn 1s ease;
}

.announcement-strip span {
    font-size: 18px;
}

.announcement-text {
    font-family: 'Cormorant Garamond', serif;
    font-size: 18px;
    color: var(--text-dark);
}

.announcement-text b {
    color: var(--accent-wine);
}

.btn-announcement {
    background: var(--accent-gold);
    color: #000;
    padding: 8px 20px;
    font-size: 12px;
    font-weight: 700;
    border-radius: 20px;
    text-decoration: none;
    text-transform: uppercase;
    transition: 0.3s;
    margin: 0;
}

.btn-announcement:hover {
    background: #b08d4e;
    color: white;
    transform: translateY(-2px);
}

/* --- GRID LAYOUT --- */
.container{
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 60px;
    padding-bottom: 100px;
    max-width: 1300px;
    margin: 0 auto;
}

@media (max-width: 1000px) {
    .container { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 600px) {
    .container { grid-template-columns: 1fr; }
}

/* --- BOOK CARDS WITH NEON GLOW --- */
.card{
    background: white;
    border-radius: 10px;
    overflow: hidden;
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    position: relative;
    border: 2px solid rgba(255,255,255,0);
    /* Base shadow */
    box-shadow: 0 10px 30px rgba(0,0,0,0.06);
    /* Proper Size Constraints */
    height: 100%;
    display: flex;
    flex-direction: column;
}

.card:hover{
    transform: translateY(-15px) scale(1.02);
    
    /* ACTIVE NEON GLOW EFFECT */
    border: 2px solid var(--neon-gold);
    box-shadow: 
        0 0 15px rgba(244, 208, 63, 0.6),   /* Inner Glow */
        0 0 35px rgba(244, 208, 63, 0.4),   /* Outer Glow */
        0 20px 40px rgba(0,0,0,0.15);       /* Depth Shadow */
}

/* Image Container for Proper Sizing */
.img-wrapper {
    width: 100%;
    height: 600px; /* Fixed height for uniformity */
    overflow: hidden;
    position: relative;
}

.card img{
    width: 100%;
    height: 100%;
    object-fit: cover; /* Ensures image fills the box without stretching */
    transition: transform 0.5s ease, filter 0.3s ease;
    filter: brightness(0.9);
}

.card:hover img {
    transform: scale(1.08);
    filter: brightness(1);
}

.card h3{
    padding: 25px 20px;
    text-align: center;
    font-family: 'Cormorant Garamond', serif;
    font-size: 24px;
    color: var(--text-dark);
    font-weight: 600;
    background: linear-gradient(to bottom, transparent, #fff 10%);
    margin-top: -20px; /* Overlap slightly */
    position: relative;
    z-index: 2;
}

a{ text-decoration:none; color: inherit; }

/* Fade In Animation */
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}

</style>

</head>

<body>

<div class="main-content">

    

    <!-- ANNOUNCEMENT STRIP -->
    <div class="announcement-strip">
        <span>🏆</span>
        <div class="announcement-text">
            Monthly Contest: <b>Write a story, win a FREE book!</b>
        </div>
        <a href="writeStory.jsp" class="btn-announcement">Join Now</a>
    </div>

    <header>
    <div class="navbar">
        <b><h1>Book Collection</h1></b>
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="collection.jsp">Collection</a>
            <a href="cart.jsp" class="cart-icon">🛒
                <span class="cart-count"><%=count%></span>
            </a>
            <a href="wishlist.jsp">Wishlist</a>
            <a href="storyWall.jsp">Stories</a>
            <a href="profile.jsp">👤</a>
        </div>
    </div>
    </header><br><br>

    <div class="container">

        <a href="category.jsp?type=love">
        <div class="card">
            <div class="img-wrapper">
                <img src="https://static.wixstatic.com/media/2a75cb_df42387fdaf647819ed2d6ef18c939bd~mv2.jpg/v1/fill/w_980,h_1504,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/2a75cb_df42387fdaf647819ed2d6ef18c939bd~mv2.jpg">
            </div>    
            <h3>Love Stories</h3>
        </div>
        </a>
        
       <a href="category.jsp?type=horror">
        <div class="card">
            <div class="img-wrapper">
                <img src="https://m.media-amazon.com/images/I/91tQgWThRxS._UF1000,1000_QL80_.jpg">
            </div>
            <h3>Horror Stories</h3>
        </div>
        </a>
        
         <a href="category.jsp?type=kids">
        <div class="card">
            <div class="img-wrapper">
                <img src="https://m.media-amazon.com/images/I/91j+XVNgHGL.jpg">
            </div>
            <h3>Kids Bed Time Stories</h3>
        </div>
        </a>

        <a href="category.jsp?type=cooking">
        <div class="card">
            <div class="img-wrapper">
                <img src="https://m.media-amazon.com/images/I/913AFUFiDzL.jpg">
            </div>
            <h3>Cooking Recipes</h3>
        </div>
        </a>
        
       
        <a href="category.jsp?type=facts">
        <div class="card">
            <div class="img-wrapper">
                <img src="https://m.media-amazon.com/images/I/81nPwPrfwpL.jpg">
            </div>
            <h3>Facts</h3>
        </div>
        </a>
       
       
        <a href="category.jsp?type=fiction">
        <div class="card">
            <div class="img-wrapper">
                <img src="https://m.media-amazon.com/images/I/714kp30ZmXL._UF1000,1000_QL80_.jpg">
            </div>
            <h3>Fiction Stories</h3>
        </div>
        </a>

    </div>

</div>

</body>
</html>