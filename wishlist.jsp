<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*,db.DBConnections" %>

<%
String email = (String)session.getAttribute("email");

if(email == null){
    response.sendRedirect("login.jsp");
    return;
}

Connection con = DBConnections.getConnection();

PreparedStatement ps = con.prepareStatement(
"SELECT * FROM wishlist WHERE email=?"
);
ps.setString(1,email);

ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<title>Wishlist</title>

<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;0,700;1,400&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">

<style>
/* --- VARIABLES --- */
:root {
    --primary-bg: #F9F7F2;
    --text-dark: #2C2C2C;
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
    display: flex;
    flex-direction: column;
    align-items: center;
    min-height: 100vh;
}

/* Page Title */
h2 {
    font-family: 'Cormorant Garamond', serif;
    font-size: 42px;
    color: var(--accent-wine);
    margin: 100px 0 40px 0;
    text-align: center;
}

/* Grid Container for Items */
.wishlist-container {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
    gap: 40px;
    width: 90%;
    max-width: 1200px;
    margin-bottom: 50px;
}

/* Item Card */
.item-card {
    background: white;
    border-radius: 8px;
    overflow: hidden;
    transition: all 0.4s ease;
    position: relative;
    border: 1px solid rgba(255,255,255,0.5);
    box-shadow: 0 5px 20px rgba(0,0,0,0.05);
    text-align: center;
    padding-bottom: 20px;
}

.item-card:hover {
    transform: translateY(-10px);
    box-shadow: 0 0 25px var(--glow-color), 
                0 20px 40px rgba(0,0,0,0.1);
    border-color: var(--accent-gold);
}

.item-card img {
    width: 100%;
    height: 300px;
    object-fit: cover;
    transition: transform 0.5s ease;
}

.item-card:hover img {
    transform: scale(1.03);
}

.item-card h3 {
    font-family: 'Cormorant Garamond', serif;
    font-size: 22px;
    color: var(--text-dark);
    margin: 15px 10px 5px 10px;
}

.item-card p {
    color: var(--accent-wine);
    font-weight: 700;
    font-size: 18px;
    margin-bottom: 20px;
}

/* Buttons Container */
.btn-group {
    display: flex;
    justify-content: center;
    gap: 10px;
    padding: 0 15px;
}

/* Button Styles (using <a> tags for links) */
.btn {
    padding: 10px 15px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    text-decoration: none;
    transition: all 0.3s;
    cursor: pointer;
    border: none;
    display: inline-block;
    text-align: center;
}

.btn-cart {
    background: var(--accent-gold);
    color: #000;
}

.btn-cart:hover {
    background: #b08d4e;
    color: white;
}

.btn-remove {
    background: transparent;
    color: #D32F2F;
    border: 1px solid #D32F2F;
}

.btn-remove:hover {
    background: #D32F2F;
    color: white;
}

/* Footer Continue Button */
.continue-btn {
    margin: 20px 0 60px 0;
    padding: 14px 50px;
    background: var(--accent-wine);
    color: white;
    border-radius: 30px;
    text-decoration: none;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 1px;
    transition: all 0.3s;
    box-shadow: 0 5px 15px rgba(114, 47, 55, 0.2);
}

.continue-btn:hover {
    background: #5a2429;
    transform: translateY(-2px);
}

/* Empty State Message */
.empty-msg {
    font-size: 18px;
    color: #666;
    margin-bottom: 30px;
}

hr { display: none; } /* Hide old lines */

/* Responsive */
@media (max-width: 600px) {
    .wishlist-container {
        grid-template-columns: 1fr;
    }
}
</style>

</head>
<body>

<h2>My Wishlist</h2>

<div class="wishlist-container">

<%
boolean hasItems = false;
while(rs.next()){
    hasItems = true;
%>

    <div class="item-card">
        <img src="<%=rs.getString("image")%>">
        
        <h3><%=rs.getString("book")%></h3>
        
        <p>₹<%=rs.getInt("price")%></p>

        <div class="btn-group">
            <!-- Move to Cart Button -->
            <a href="moveToCart.jsp?id=<%=rs.getInt("id")%>" class="btn btn-cart">
                Move to Cart
            </a>

            <!-- Remove Button -->
            <a href="removeWishlist.jsp?id=<%=rs.getInt("id")%>" class="btn btn-remove">
                Remove
            </a>
        </div>
    </div>

<% 
} 
%>

</div>

<% if(!hasItems) { %>
    <p class="empty-msg">Your wishlist is empty.</p>
<% } %>

<a href="collection.jsp" class="continue-btn">Continue Shopping</a>

</body>
</html>