<%@ page import="java.sql.*,db.DBConnections" %>
<%@ page contentType="text/html;charset=UTF-8" %>


<%
String name = (String)session.getAttribute("name");
String email = (String)session.getAttribute("email");
String phone = (String)session.getAttribute("phone");
String address = (String)session.getAttribute("address");

if(email == null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>My Profile</title>

<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;0,700;1,400&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">

<style>
/* --- VARIABLES --- */
:root {
    --primary-bg: #F9F7F2;
    --text-dark: #2C2C2C;
    --text-light: #666666;
    --accent-wine: #722F37;
    --accent-gold: #C5A059;
    --glow-color: rgba(197, 160, 89, 0.4);
}

body{
    font-family: 'Lato', sans-serif;
    background-color: var(--primary-bg);
    background-image: url('https://www.toptal.com/designers/subtlepatterns/patterns/cream_paper.png');
    color: var(--text-dark);
    margin: 0;
    padding: 0;
    min-height: 100vh;
}

/* --- HEADER / NAVBAR --- */
.header{
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    padding: 20px 60px;
    border-bottom: 1px solid rgba(197, 160, 89, 0.3);
    color: var(--accent-wine);
    font-family: 'Cormorant Garamond', serif;
    font-size: 28px;
    font-weight: 700;
    text-align: center;
    position: fixed;
    width: 100%;
    top: 0;
    z-index: 1000;
    box-shadow: 0 4px 20px rgba(0,0,0,0.03);
}

/* Main Container */
.container{
    max-width: 800px;
    margin: 120px auto 50px auto;
    padding: 0 20px;
}

/* --- PROFILE CARD --- */
.profile-box{
    background: white;
    padding: 40px;
    border-radius: 12px;
    text-align: center;
    box-shadow: 0 10px 30px rgba(0,0,0,0.05);
    margin-bottom: 40px;
    border: 1px solid rgba(197, 160, 89, 0.2);
    position: relative;
    overflow: hidden;
}

/* Decorative top border */
.profile-box::before {
    content: '';
    position: absolute;
    top: 0; left: 0; width: 100%; height: 5px;
    background: var(--accent-wine);
}

/* Avatar Icon */
.avatar {
    width: 100px;
    height: 100px;
    background: var(--primary-bg);
    border-radius: 50%;
    margin: 0 auto 20px auto;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 40px;
    color: var(--accent-wine);
    border: 2px solid var(--accent-gold);
}

.profile-box h2 {
    font-family: 'Cormorant Garamond', serif;
    font-size: 32px;
    color: var(--accent-wine);
    margin: 0 0 20px 0;
}

.info-item {
    margin: 10px 0;
    font-size: 15px;
    color: var(--text-dark);
}

.info-item b {
    color: var(--text-light);
    font-weight: 400;
    margin-right: 10px;
}

/* Profile Action Buttons */
.profile-actions {
    margin-top: 30px;
    display: flex;
    justify-content: center;
    gap: 15px;
}

.btn{
    padding: 12px 30px;
    border: none;
    border-radius: 30px;
    font-family: 'Lato', sans-serif;
    font-weight: 600;
    font-size: 13px;
    text-transform: uppercase;
    letter-spacing: 1px;
    cursor: pointer;
    transition: all 0.3s;
    text-decoration: none;
}

.edit{
    background: var(--accent-gold);
    color: #000;
}

.edit:hover{
    background: #b08d4e;
    color: white;
    box-shadow: 0 5px 15px rgba(197, 160, 89, 0.4);
}

.address{
    background: var(--accent-wine);
    color: white;
}

.address:hover{
    background: #5a2429;
    box-shadow: 0 5px 15px rgba(114, 47, 55, 0.4);
}

/* --- MENU CARDS --- */
.card{
    background: white;
    padding: 25px 30px;
    margin-bottom: 15px;
    border-radius: 8px;
    cursor: pointer;
    display: flex;
    justify-content: space-between;
    align-items: center;
    transition: all 0.3s ease;
    border: 1px solid rgba(255,255,255,0.5);
    box-shadow: 0 2px 10px rgba(0,0,0,0.03);
}

.card:hover{
    transform: translateX(10px);
    background: #fff;
    border-color: var(--accent-gold);
    box-shadow: 0 5px 20px rgba(0,0,0,0.05), 0 0 10px var(--glow-color);
}

.card-left {
    display: flex;
    align-items: center;
    gap: 20px;
}

.card-icon {
    font-size: 24px;
}

.card-text {
    font-size: 16px;
    font-weight: 600;
    color: var(--text-dark);
}

.arrow {
    color: var(--accent-gold);
    font-weight: bold;
}

/* --- LOGOUT --- */
.logout-container {
    text-align: center;
    margin-top: 40px;
}

.logout{
    padding: 14px 50px;
    background: transparent;
    color: var(--accent-wine);
    border: 2px solid var(--accent-wine);
    border-radius: 30px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.3s;
    font-size: 14px;
    text-transform: uppercase;
}

.logout:hover{
    background: var(--accent-wine);
    color: white;
    box-shadow: 0 5px 15px rgba(114, 47, 55, 0.2);
}

/* Responsive */
@media (max-width: 600px) {
    .container {
        width: 95%;
    }
    .profile-actions {
        flex-direction: column;
    }
    .btn {
        width: 100%;
    }
}
</style>

</head>

<body>

<div class="header">My Account</div>

<div class="container">

    <div class="profile-box">
        <div class="avatar">👤</div>
        <h2><%=name%></h2>
        
        <div class="info-item"><b>Email:</b> <%=email%></div>
        <div class="info-item"><b>Phone:</b> <%= (phone!=null && !phone.equals("null") ? phone : "Not Added") %></div>
        <div class="info-item"><b>Address:</b> <%= (address!=null && !address.equals("null") ? address : "Not Added") %></div>

        <div class="profile-actions">
            <a href="editProfile.jsp"><button class="btn edit">Edit Profile</button></a>
            <a href="address.jsp"><button class="btn address">Add Address</button></a>

        </div>
    </div>

    <!-- Menu Items -->
    <div class="card" onclick="location.href='storyWall.jsp'">
        <div class="card-left">
            <span class="card-icon">✍️</span>
            <span class="card-text">View Stories</span>
        </div>
        <span class="arrow">➤</span>
    </div>
    <div class="card" onclick="location.href='orders.jsp'">
        <div class="card-left">
            <span class="card-icon">📦</span>
            <span class="card-text">My Orders</span>
        </div>
        <span class="arrow">➤</span>
    </div>

    <div class="card" onclick="location.href='wishlist.jsp'">
        <div class="card-left">
            <span class="card-icon">❤️</span>
            <span class="card-text">Wishlist</span>
        </div>
        <span class="arrow">➤</span>
    </div>

    <div class="card" onclick="location.href='cart.jsp'">
        <div class="card-left">
            <span class="card-icon">🛒</span>
            <span class="card-text">My Cart</span>
        </div>
        <span class="arrow">➤</span>
    </div>

    <div class="logout-container">
        <a href="logout.jsp"><button class="logout">Logout</button></a>
    </div>

</div>

</body>
</html>