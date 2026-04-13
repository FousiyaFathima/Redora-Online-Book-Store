<%@page import="java.util.ArrayList"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*,db.DBConnections"%>
<%@page contentType="text/html;charset=UTF-8" %>

<%
/* ---------------- NAV CART COUNT ---------------- */
String email_nav = (String)session.getAttribute("email");
int count = 0;

if(email_nav != null){
    try {
        Connection con_nav = DBConnections.getConnection();
        PreparedStatement ps_nav = con_nav.prepareStatement("SELECT SUM(qty) FROM cart WHERE email=?");
        ps_nav.setString(1, email_nav);
        ResultSet rs_nav = ps_nav.executeQuery();
        if(rs_nav.next()){
            count = rs_nav.getInt(1);
        }
    } catch(Exception e) { e.printStackTrace(); }
}

/* ---------------- CATEGORY LOGIC ---------------- */
String type = request.getParameter("type");
if(type == null) type = "love";

String title = "Book Collection";
String[][] booksData = null;

/* ---------------- STATIC BOOKS DATA ---------------- */
if(type.equals("love")){
    title="Romantic Love Books";
    booksData = new String[][]{
        {"Love in Paris", "https://m.media-amazon.com/images/I/61pR3rrmVlL.jpg", "250", "5", "1", "A heartfelt story of two strangers finding love in the city of lights."},
        {"Forever With You", "https://m.media-amazon.com/images/I/61RA5nE6zpL.jpg", "300", "4", "1", "A journey of eternal promises and second chances at love."},
        {"Broken Hearts", "https://m.media-amazon.com/images/I/61ugydGRVAL.jpg", "200", "4", "1", "Healing from the past and finding hope in new beginnings."},
        {"Secret Romance", "https://m.media-amazon.com/images/I/91Kz7dW6fPL.jpg", "350", "5", "0", "A forbidden love story that defies all boundaries."},
        {"Dream Love", "https://m.media-amazon.com/images/I/61kkWOmHSeL.jpg", "400", "3", "1", "Is it real or just a dream? A mystical romance tale."},
        {"Eternal Promise", "https://m.media-amazon.com/images/I/71GH+aBu6EL.jpg", "280", "4", "1", "Vows that last a lifetime tested by time and distance."},
        {"Lost Love", "https://m.media-amazon.com/images/I/51gtSR9QOfL.jpg", "320", "5", "1", "Searching for a lost connection across continents."},
        {"Sweet Memories", "https://m.media-amazon.com/images/I/71eFKdpmJrL.jpg", "220", "4", "1", "A nostalgic trip down memory lane of first loves."},
        {"True Love Story", "https://m.media-amazon.com/images/I/51o3j0MtMhL.jpg", "260", "5", "1", "A real-life inspired story of unconditional love."},
        {"Endless Love", "https://m.media-amazon.com/images/I/61A5NteSm4L.jpg", "380", "4", "1", "Love that knows no end, transcending lifetimes."}
    };
}
else if(type.equals("fiction")){
    title="Fiction Books";
    booksData = new String[][]{
        {"Harry Potter", "https://m.media-amazon.com/images/I/51dOacmuzvL._SY445_SX342_FMwebp_.jpg", "550", "5", "1", "The boy who lived discovers his magical heritage."},
        {"The Hobbit", "https://m.media-amazon.com/images/I/512WlnAvYlL._SY445_SX342_FMwebp_.jpg", "450", "5", "1", "A reluctant hobbit sets out on a quest to reclaim a treasure."},
        {"The Alchemist", "https://m.media-amazon.com/images/I/41ziEX0PJgL._SY445_SX342_FMwebp_.jpg", "350", "4", "1", "A journey of self-discovery following one's dreams."},
        {"The Da Vinci Code", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQM8AxnOmlAgAVv6kLElwh_S0dXcqBdX4DNUA&s", "400", "4", "0", "A thriller unraveling religious mysteries and secrets."},
        {"Percy Jackson", "https://m.media-amazon.com/images/I/517cdDQLznL._SY445_SX342_FMwebp_.jpg", "380", "5", "1", "A demigod's adventure in a modern mythological world."},
        {"The Hunger Games", "https://m.media-amazon.com/images/I/51n4GJK-TGS._SY445_SX342_FMwebp_.jpg", "320", "4", "1", "A dystopian fight for survival in a televised arena."},
        {"The Book Thief", "https://m.media-amazon.com/images/I/41CsQkIYzaL._SY445_SX342_QL70_FMwebp_.jpg", "300", "5", "1", "A story narrated by Death about a girl stealing books in WWII."},
        {"Te Maze Runner", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSr2D6HitPXj1toiaJ60lXjgnOjTGU2ty7Oaw&s", "340", "3", "1", "Teens trapped in a deadly maze must find a way out."},
        {"Dune", "https://m.media-amazon.com/images/I/51+0y1mtPiL._SY445_SX342_FMwebp_.jpg", "500", "5", "1", "An epic tale of politics and survival on a desert planet."},
        {"The Giver","https://m.media-amazon.com/images/I/41AK8KH8diL._SY445_SX342_FMwebp_.jpg", "280", "4", "1", "A boy discovers the dark secrets of his utopian society."}
    };
}
else if(type.equals("horror")){
    title="Horror Books";
    booksData = new String[][]{
        {"It", "https://m.media-amazon.com/images/I/A1NPvRgil6L.jpg", "450", "5", "1", "Pennywise the clown terrorizes a small town every 27 years."},
        {"The Shining", "https://m.media-amazon.com/images/I/811d1c8ik3L.jpg", "400", "5", "1", "A family's descent into madness in an isolated hotel."},
        {"Dracula", "https://m.media-amazon.com/images/I/817oQE9KceL._UF1000,1000_QL80_.jpg", "300", "4", "1", "The classic gothic tale of the vampire from Transylvania."},
        {"Frankenstein", "https://m.media-amazon.com/images/I/81no7fSRLcL.jpg", "280", "4", "0", "A scientist's creation turns into a monster."},
        {"The Exorcist", "https://m.media-amazon.com/images/I/612y1xDU+lL.jpg", "350", "5", "1", "A terrifying battle for a young girl's soul."},
        {"Pet Sematary", "https://m.media-amazon.com/images/I/91o56ivn0KL.jpg", "380", "4", "1", "Sometimes dead is better... a burial ground's dark power."},
        {"The Bird Box", "https://m.media-amazon.com/images/I/815WObgvctL.jpg", "320", "3", "1", "Survival in a world where seeing means death."},
        {"Coraline", "https://m.media-amazon.com/images/I/91Wr0j5lr7L.jpg", "250", "4", "1", "A door to another world where parents have buttons for eyes."},
        {"Haunting of Hill House", "https://m.media-amazon.com/images/I/81FMksyikrL.jpg", "270", "5", "1", "Psychological horror within the walls of a mansion."},
        {"House of Leaves","https://m.media-amazon.com/images/I/71CCbGpwWtL.jpg", "420", "3", "1", "A labyrinthine house that is bigger on the inside."}
    };
}
else if(type.equals("kids")){
    title="Kids Story Books";
    booksData = new String[][]{
        {"Cinderella", "https://m.media-amazon.com/images/I/81umhGUT4HL.jpg", "150", "5", "1", "A classic fairy tale of a girl, a glass slipper, and a prince."},
        {"Snow White", "https://m.media-amazon.com/images/I/91xE1kPhFcL.jpg", "150", "4", "1", "A princess, seven dwarfs, and a wicked stepmother."},
        {"The Little Mermaid", "https://m.media-amazon.com/images/I/91j+XVNgHGL.jpg", "160", "4", "1", "A mermaid dreams of life above the waves."},
        {"Beauty and the Beast", "https://m.media-amazon.com/images/I/81Hm-uJbeUL.jpg", "170", "5", "0", "True love lies within, beyond appearances."},
        {"Peter Pan", "https://m.media-amazon.com/images/I/41U0If0tjcL._AC_UF1000,1000_QL80_.jpg", "140", "5", "1", "The boy who wouldn't grow up in Neverland."},
        {"The Jungle Book", "https://m.media-amazon.com/images/I/41cDyW3qIjL._AC_UF1000,1000_QL80_.jpg", "180", "4", "1", "Mowgli's adventures with wolves and Sher Khan."},
        {"Pinocchio", "https://m.media-amazon.com/images/I/81dqMLgoYOL.jpg", "130", "3", "1", "A wooden puppet who wants to become a real boy."},
        {"Charlotte's Web", "https://m.media-amazon.com/images/I/717rq-5Dk7L.jpg", "200", "5", "1", "A friendship between a pig and a wise spider."},
        {"Winnie the Pooh", "https://m.media-amazon.com/images/I/71MGVty0d-L.jpg", "190", "4", "1", "Adventures of a bear and his friends in the Hundred Acre Wood."},
        {"Matilda", "https://m.media-amazon.com/images/I/81yG3xAVpnL.jpg", "220", "5", "1", "A genius girl with special powers and mean parents."}
    };
}

else if(type.equals("cooking")){
    title="Cooking & Recipes";
    booksData = new String[][]{
        {"The Fun Of Cooking", "https://m.media-amazon.com/images/I/71hPiQTdIRL.jpg", "600", "5", "1", "The definitive guide to French cuisine for home cooks."},
        {"Food Story", "https://m.media-amazon.com/images/I/815dpRYL9dL.jpg", "550", "5", "1", "Mastering the elements of good cooking."},
        {"The Complete Cookbook", "https://m.media-amazon.com/images/I/919XPk0tObL.jpg", "400", "4", "1", "A comprehensive guide to every meal of the day."},
        {"THE Joy of Cooking", "https://m.media-amazon.com/images/I/61TdzdcWbUL.jpg", "450", "4", "0", "A classic American kitchen staple for generations."},
        {"THE Indian Kitchen", "https://m.media-amazon.com/images/I/913AFUFiDzL.jpg", "350", "5", "1", "Authentic Indian recipes passed down generations."},
        {"Simple Cooking", "https://m.media-amazon.com/images/I/61dtdkaUbZL.jpg", "300", "3", "1", "Quick and easy recipes for busy lifestyles."},
        {"Baking Bible", "https://m.media-amazon.com/images/I/71d-2bmvqRL.jpg", "500", "5", "1", "The ultimate guide to cakes, breads, and pastries."},
        {"Healthy Recipes", "https://m.media-amazon.com/images/I/71VLB0nO2LL.jpg", "320", "4", "1", "Nutritious meals that taste delicious."},
        {"Quick Meals", "https://m.media-amazon.com/images/I/711Q-pzh6EL.jpg", "280", "4", "1", "30-minute meals for the whole family."},
        {"Flame & Flavor: An Indian culinary journey", "https://m.media-amazon.com/images/I/71Akq6yRVkL.jpg", "340", "3", "1", "Comfort food recipes for the soul."}
    };
}
else if(type.equals("facts")){
    title="Facts & Knowledge";
    booksData = new String[][]{
        {"1000 Amazing Facts", "https://m.media-amazon.com/images/I/519kct1OAUL.jpg", "500", "5", "1", "A brief history of humankind from stone age to silicon."},
        {"Homo Deus", "https://m.media-amazon.com/images/I/51eZ7gis6kL.jpg", "550", "4", "1", "A glimpse into the future of humanity."},
        {"Brief History of Time", "https://m.media-amazon.com/images/I/81+pYBHsN-L.jpg", "400", "5", "1", "Stephen Hawking explores the universe's secrets."},
        {"Atomic Habits", "https://m.media-amazon.com/images/I/719DkcNS9xL.jpg", "350", "5", "0", "Tiny changes, remarkable results. Building good habits."},
        {"Think and Grow Rich", "https://m.media-amazon.com/images/I/612-HyllWHL.jpg", "250", "4", "1", "Principles of success and wealth accumulation."},
        {"Rich Dad Poor Dad", "https://m.media-amazon.com/images/I/81nPwPrfwpL.jpg", "300", "5", "1", "What the rich teach their kids about money."},
        {"The Power of Habit", "https://m.media-amazon.com/images/I/71PnukwDUeL.jpg", "320", "4", "1", "Why we do what we do in life and business."},
        {"Outliers", "https://m.media-amazon.com/images/I/51ptbl0Rv+L.jpg", "380", "4", "1", "The story of success and hidden advantages."},
        {"Deep Work", "https://m.media-amazon.com/images/I/41HvOQ3HyTL.jpg", "300", "5", "1", "Rules for focused success in a distracted world."},
        {"Ikigai", "https://m.media-amazon.com/images/I/81CPRLPl32L.jpg", "280", "4", "1", "The Japanese secret to a long and happy life."}
    };
}

// Get Search Query
String searchQuery = request.getParameter("search");
if(searchQuery == null) searchQuery = "";
%>

<!DOCTYPE html>
<html>
<head>
<title><%=title%></title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;0,700;1,400&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<style>
/* --- AESTHETIC VARIABLES --- */
:root {
    --primary-bg: #F9F7F2;
    --text-dark: #2C2C2C;
    --accent-wine: #722F37;
    --accent-gold: #C5A059;
    --glow-color: rgba(197, 160, 89, 0.6);
}

* { margin: 0; padding: 0; box-sizing: border-box; }

body{
    font-family: 'Lato', sans-serif;
    color: var(--text-dark);
    background-color: #fdfcf9;
    background-image: linear-gradient(135deg, #fff 0%, #f4f1ea 100%), url('https://www.transparenttextures.com/patterns/cream-paper.png');
    position: relative;
}

/* --- NAVBAR --- */
.navbar{
    display: flex; justify-content: space-between; align-items: center;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    padding: 20px 60px;
    border-bottom: 1px solid rgba(197, 160, 89, 0.3);
    position: fixed; width: 100%; top: 0; z-index: 1000;
    box-shadow: 0 4px 20px rgba(0,0,0,0.05);
}

.logo {
    font-family: 'Cormorant Garamond', serif;
    font-size: 32px;
    color: var(--accent-wine);
    text-decoration: none;
    font-weight: 700;
    letter-spacing: 3px;
    text-transform: uppercase;
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
.cart-count{ position: absolute; top: -8px; right: -10px; background: var(--accent-wine); color: white; border-radius: 50%; padding: 2px 6px; font-size: 10px; }

/* --- HEADER & SEARCH --- */
.header-section {
    margin-top: 120px;
    text-align: center;
    margin-bottom: 40px;
}

.page-title {
    font-family: 'Cormorant Garamond', serif;
    font-size: 56px;
    color: var(--accent-wine);
    margin-bottom: 30px;
    letter-spacing: 2px;
    text-shadow: 
        0 0 10px rgba(197, 160, 89, 0.8), 
        0 0 20px rgba(197, 160, 89, 0.6), 
        0 0 30px rgba(197, 160, 89, 0.4);
}

.search-box {
    display: inline-block;
    position: relative;
    width: 100%;
    max-width: 500px;
    margin: 0 auto;
}

.search-box input {
    width: 100%;
    padding: 16px 25px;
    border: 2px solid rgba(197, 160, 89, 0.3);
    border-radius: 50px;
    background: white;
    font-family: 'Lato', sans-serif;
    font-size: 16px;
    color: var(--text-dark);
    transition: all 0.3s;
    box-shadow: 0 5px 20px rgba(0,0,0,0.05);
}

.search-box input:focus {
    outline: none;
    border-color: var(--accent-gold);
    box-shadow: 0 0 15px rgba(197, 160, 89, 0.3);
}

.search-btn {
    position: absolute;
    right: 5px;
    top: 5px;
    background: var(--accent-wine);
    color: white;
    border: none;
    border-radius: 50%;
    width: 44px;
    height: 44px;
    cursor: pointer;
    transition: all 0.3s;
}

.search-btn:hover { background: #5a2429; transform: scale(1.1); }

/* --- GRID & CARDS --- */
.grid{
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
    gap: 40px;
    padding: 0 70px 80px 70px;
    max-width: 1600px; margin: 0 auto;
}

.book{
    background: white;
    border-radius: 10px;
    overflow: hidden;
    transition: all 0.4s ease;
    position: relative;
    border: 2px solid rgba(255, 255, 255, 0.5);
    box-shadow: 0 10px 30px rgba(0,0,0,0.06);
    display: flex;
    flex-direction: column;
    height: 100%;
}

.book:hover{
    transform: translateY(-15px) scale(1.02);
    border: 2px solid var(--accent-gold);
    box-shadow: 
        0 0 15px rgba(244, 208, 63, 0.6), 
        0 0 35px rgba(244, 208, 63, 0.4), 
        0 20px 40px rgba(0,0,0,0.15);
}

.img-container { width:100%; height: 400px; overflow: hidden; position: relative; }
.book img{ width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s ease; filter: brightness(0.9); }
.book:hover img { transform: scale(1.08); filter: brightness(1); }

/* Labels */
.label-badge { position: absolute; padding: 5px 12px; font-size: 11px; font-weight: 700; border-radius: 20px; z-index: 2; text-transform: uppercase; }
.rating-badge { top: 15px; left: 15px; background: var(--accent-gold); color: #000; }
.stock-badge { top: 15px; right: 15px; }
.in-stock { background: #4CAF50; color: white; }
.out-stock { background: #F44336; color: white; }

.book-info { padding: 25px; flex-grow: 1; display: flex; flex-direction: column; }
.book h3{ font-family: 'Cormorant Garamond', serif; font-size: 24px; color: var(--text-dark); margin-bottom: 5px; }
.book .price { color: var(--accent-wine); font-weight: 700; font-size: 20px; margin-bottom: 15px; }
.book .desc { font-size: 14px; color: #666; line-height: 1.6; margin-bottom: 20px; flex-grow: 1; }

/* BUTTON LOGIC */
.smart-btn-container { display: flex; width: 100%; border: 1px solid #eee; border-radius: 6px; overflow: hidden; margin-top: auto; }
.qty-adjust { width: 40px; background: #f9f9f9; border: none; font-size: 18px; font-weight: bold; cursor: pointer; color: var(--text-dark); transition: background 0.3s; }
.qty-adjust:hover { background: var(--accent-gold); color: white; }
.btn-add { flex-grow: 1; padding: 12px; background: var(--accent-wine); color: white; border: none; font-weight: 700; font-size: 14px; text-transform: uppercase; letter-spacing: 1px; cursor: pointer; transition: background 0.3s; text-decoration: none; display: flex; align-items: center; justify-content: center; }
.btn-add:hover { background: #5a2429; }
.wish-btn-sec { margin-top: 10px; text-align: center; }
.wish-link { color: #999; text-decoration: none; font-size: 13px; transition: color 0.3s; }
.wish-link:hover { color: var(--accent-wine); }

/* No Results */
.no-results { text-align: center; margin-top: 50px; font-size: 18px; color: #888; }

</style>

<script>
function changeQty(btn, change, linkId) {
    var container = btn.closest('.smart-btn-container');
    var display = container.querySelector('.qty-val');
    var link = document.getElementById(linkId);
    
    var currentQty = parseInt(display.innerText);
    var newQty = currentQty + change;
    
    if(newQty < 1) newQty = 1;
    display.innerText = newQty;
    
    var currentHref = link.getAttribute('data-base-href');
    link.href = currentHref + "&qty=" + newQty;
}
</script>

</head>
<body>

<header>
    <div class="navbar">
        <a href="index.jsp" class="logo">READORA</a>
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="collection.jsp">Collection</a>
            <a href="cart.jsp" class="cart-icon">🛒
                <span class="cart-count"><%=count%></span>
            </a>
            <a href="wishlist.jsp">Wishlist</a>
            <a href="profile.jsp">👤</a>
        </div>
    </div>
</header>

<div class="header-section">
    <h1 class="page-title"><%=title%></h1>
    
    <form method="get" action="category.jsp">
        <input type="hidden" name="type" value="<%=type%>">
        <div class="search-box">
            <input type="text" name="search" placeholder="Search within this category..." value="<%=searchQuery%>">
            <button type="submit" class="search-btn"><i class="fa fa-search"></i></button>
        </div>
    </form>
</div>

<div class="grid">

<%
boolean foundResults = false;

// --- 1. STATIC BOOKS LOOP ---
if(booksData != null) {
    for(int i=0; i<booksData.length; i++){
        String bookName = booksData[i][0];
        
        if(searchQuery != null && !searchQuery.trim().equals("")){
            if(!bookName.toLowerCase().contains(searchQuery.toLowerCase())){
                continue;
            }
        }
        
        foundResults = true;
        String bookImg = booksData[i][1];
        int price = Integer.parseInt(booksData[i][2]);
        String rating = booksData[i][3];
        boolean inStock = booksData[i][4].equals("1");
        String desc = booksData[i][5];
        
        String encName = URLEncoder.encode(bookName, "UTF-8");
        String encImg = URLEncoder.encode(bookImg, "UTF-8");
        String cartBase = "addToCartDB.jsp?bookls="+encName+"&price="+price+"&image="+encImg+"&type="+type;
        String wishUrl = "wishlistDB.jsp?bookls="+encName+"&price="+price+"&image="+encImg+"&type="+type;
        String linkId = "link_s" + i;
%>
    <div class="book">
        <div class="img-container">
            <span class="label-badge rating-badge">
                <% for(int s=0; s<Integer.parseInt(rating); s++) { %>★<% } %>
            </span>
            <span class="label-badge stock-badge <%= inStock ? "in-stock" : "out-stock" %>">
                <%= inStock ? "In Stock" : "Out of Stock" %>
            </span>
            <img src="<%=bookImg%>" alt="<%=bookName%>">
        </div>
        
        <div class="book-info">
            <h3><%=bookName%></h3>
            <p class="price">₹<%=price%></p>
            <p class="desc"><%=desc%></p>
            
            <div class="smart-btn-container">
                <button type="button" class="qty-adjust" onclick="changeQty(this, -1, '<%=linkId%>')">-</button>
                <a id="<%=linkId%>" href="<%=cartBase%>&qty=1" class="btn-add" data-base-href="<%=cartBase%>">
                    Add <span class="qty-val">1</span> to Cart
                </a>
                <button type="button" class="qty-adjust" onclick="changeQty(this, 1, '<%=linkId%>')">+</button>
            </div>
            
            <div class="wish-btn-sec">
                <a href="<%=wishUrl%>" class="wish-link">❤️ Add to Wishlist</a>
            </div>
        </div>
    </div>
<%
    }
}
%>

<!-- ---------------- 2. DATABASE BOOKS LOOP (Admin Added) ---------------- -->
<%
try {
    Connection con = DBConnections.getConnection();
    PreparedStatement ps = con.prepareStatement("SELECT * FROM books WHERE type=?");
    ps.setString(1, type);
    ResultSet rs = ps.executeQuery();

    int i = booksData != null ? booksData.length : 0; 
    while(rs.next()){
        String bookName = rs.getString("title"); 
        String bookImg = rs.getString("image");
        int price = rs.getInt("price");
        String rating = "4"; 
        boolean inStock = true;
        String desc = "An amazing book to read.";

        String encName = URLEncoder.encode(bookName, "UTF-8");
        String encImg = URLEncoder.encode(bookImg, "UTF-8");
        String cartBase = "addToCartDB.jsp?bookls="+encName+"&price="+price+"&image="+encImg+"&type="+type;
        String wishUrl = "wishlistDB.jsp?bookls="+encName+"&price="+price+"&image="+encImg+"&type="+type;
        String linkId = "link_db" + i;
%>
    <div class="book">
        <div class="img-container">
            <span class="label-badge rating-badge">
                <% for(int s=0; s<Integer.parseInt(rating); s++) { %>★<% } %>
            </span>
            <span class="label-badge stock-badge <%= inStock ? "in-stock" : "out-stock" %>">
                <%= inStock ? "In Stock" : "Out of Stock" %>
            </span>
            <img src="<%=bookImg%>" alt="<%=bookName%>">
        </div>
        
        <div class="book-info">
            <h3><%=bookName%></h3>
            <p class="price">₹<%=price%></p>
            <p class="desc"><%=desc%></p>
            
            <div class="smart-btn-container">
                <button type="button" class="qty-adjust" onclick="changeQty(this, -1, '<%=linkId%>')">-</button>
                <a id="<%=linkId%>" href="<%=cartBase%>&qty=1" class="btn-add" data-base-href="<%=cartBase%>">
                    Add <span class="qty-val">1</span> to Cart
                </a>
                <button type="button" class="qty-adjust" onclick="changeQty(this, 1, '<%=linkId%>')">+</button>
            </div>
            
            <div class="wish-btn-sec">
                <a href="<%=wishUrl%>" class="wish-link">❤️ Add to Wishlist</a>
            </div>
        </div>
    </div>
<%
        i++;
    }
    con.close();
} catch(Exception e) {
    e.printStackTrace();
}

// Display message if no results found
if(!foundResults) {
%>
    <div class="no-results">
        <h3>No books found matching "<%=searchQuery%>"</h3>
        <p>Try searching for another title.</p>
    </div>
<%
}
%>

</div>

</body>
</html>