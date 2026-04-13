<%@page import="java.util.ArrayList"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.sql.*,java.util.*,db.DBConnections" %>

<%
String email = (String)session.getAttribute("email");

if(email == null){
    response.sendRedirect("login.jsp");
    return;
}

/* 🔥 LOAD CART FROM DB */
ArrayList<String> books = new ArrayList<String>();
ArrayList<Integer> prices = new ArrayList<Integer>();
ArrayList<String> images = new ArrayList<String>();
ArrayList<Integer> qty = new ArrayList<Integer>();
Connection con = DBConnections.getConnection();

PreparedStatement ps = con.prepareStatement(
"SELECT * FROM cart WHERE email=?"
);

ps.setString(1,email);
ResultSet rs = ps.executeQuery();

while(rs.next()){
    books.add(rs.getString("book"));
    prices.add(rs.getInt("price"));
    images.add(rs.getString("image"));
    qty.add(rs.getInt("qty"));
}

/* 🚨 EMPTY CART CHECK */
if(books.size() == 0){
    response.sendRedirect("cart.jsp");
    return;
}
%>

<html>
<head>
<title>Order Page</title>

<!-- Google Fonts Link (Put this in head) -->
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;0,700;1,400&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">

<style>
/* --- VARIABLES --- */
:root {
    --primary-bg: #F9F7F2;
    --text-dark: #2C2C2C;
    --accent-wine: #722F37;
    --accent-gold: #C5A059;
    --input-bg: #FFFFFF;
}

body{
    font-family: 'Lato', sans-serif;
    background-color: var(--primary-bg);
    background-image: url('https://www.toptal.com/designers/subtlepatterns/patterns/cream_paper.png');
    color: var(--text-dark);
    margin: 0;
}

.container{
    display: flex;
    width: 90%;
    max-width: 1200px;
    margin: auto;
    margin-top: 120px; /* Space for navbar */
    gap: 40px;
    padding-bottom: 50px;
    align-items: flex-start;
}

/* Left Side: Cart Summary */
.book-box{
    width: 35%;
    background: white;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.05);
    border: 1px solid rgba(197, 160, 89, 0.2);
    position: sticky;
    top: 100px;
}

.book-box h3 {
    font-family: 'Cormorant Garamond', serif;
    font-size: 28px;
    color: var(--accent-wine);
    margin-bottom: 20px;
    border-bottom: 1px solid #eee;
    padding-bottom: 10px;
}

.book-box img {
    width: 60px;
    height: 80px;
    object-fit: cover;
    border-radius: 4px;
    margin-right: 15px;
    float: left;
}

.book-box p {
    font-size: 14px;
    margin: 5px 0;
}

.book-box hr {
    border: 0;
    border-top: 1px solid #eee;
    margin: 15px 0;
    clear: both;
}

.book-box h3:last-of-type {
    text-align: right;
    color: var(--text-dark);
    margin-top: 20px;
}

/* Right Side: Form */
.form-box{
    width: 65%;
    background: white;
    padding: 40px;
    border-radius: 10px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.05);
    border: 1px solid rgba(197, 160, 89, 0.2);
}

.form-box h2 {
    font-family: 'Cormorant Garamond', serif;
    font-size: 32px;
    color: var(--accent-wine);
    margin-bottom: 30px;
}

input, select{
    width: 100%;
    padding: 14px 20px;
    margin: 10px 0 5px 0;
    border: 1px solid #ddd;
    border-radius: 6px;
    background: #fff;
    font-family: 'Lato', sans-serif;
    font-size: 14px;
    transition: border-color 0.3s, box-shadow 0.3s;
}

input:focus, select:focus {
    outline: none;
    border-color: var(--accent-gold);
    box-shadow: 0 0 10px rgba(197, 160, 89, 0.2);
}

/* Validation Styles */
.valid { 
    border: 1px solid var(--accent-gold) !important; 
    background-color: rgba(197, 160, 89, 0.05);
}

.error{ 
    color: #D32F2F; 
    font-size: 12px; 
    display: block;
    margin-bottom: 10px;
}

.success{ 
    color: var(--accent-wine); 
    font-size: 12px; 
}

h3 {
    margin-top: 20px;
    font-family: 'Cormorant Garamond', serif;
    font-size: 22px;
}

/* Payment Options Box */
.payment-box{
    background: #F9F7F2;
    padding: 20px;
    border-radius: 8px;
    margin-top: 15px;
    border: 1px solid #eee;
}

/* Place Order Button */
button{
    width: 100%;
    padding: 16px;
    background: var(--accent-gold);
    color: #000;
    border: none;
    border-radius: 30px;
    cursor: pointer;
    font-family: 'Lato', sans-serif;
    font-weight: 700;
    font-size: 14px;
    text-transform: uppercase;
    letter-spacing: 2px;
    transition: all 0.3s;
    margin-top: 30px;
    box-shadow: 0 5px 15px rgba(197, 160, 89, 0.3);
}

button:hover{
    background: #b08d4e;
    transform: translateY(-2px);
    box-shadow: 0 10px 20px rgba(197, 160, 89, 0.4);
}

/* Responsive */
@media (max-width: 900px) {
    .container {
        flex-direction: column;
        margin-top: 100px;
    }
    .book-box, .form-box {
        width: 100%;
        position: static;
    }
}
</style>

<script>
function validate(id, condition){
let input=document.getElementById(id);
if(condition){
input.classList.add("valid");
return true;
}else{
input.classList.remove("valid");
return false;
}
}

function finalCheck(){
return true; // keep simple for now
}

function showPayment(){
let val=document.getElementById("payment").value;
document.getElementById("upi").style.display="none";
document.getElementById("card").style.display="none";
document.getElementById("net").style.display="none";

if(val=="UPI") document.getElementById("upi").style.display="block";
if(val=="Card") document.getElementById("card").style.display="block";
if(val=="Net") document.getElementById("net").style.display="block";
}
function setValid(id, msg){
document.getElementById(id).style.border="2px solid green";
document.getElementById(id+"Error").innerHTML=msg;
document.getElementById(id+"Error").style.color="lightgreen";
}

function setError(id, msg){
document.getElementById(id).style.border="2px solid red";
document.getElementById(id+"Error").innerHTML=msg;
document.getElementById(id+"Error").style.color="red";
}

/* NAME */
function validateName(){
let v=name.value;
if(/^[A-Za-z ]{3,}$/.test(v)) setValid("name","✔ Good");
else setError("name","❌ Invalid name");
}

/* ADDRESS */
function validateAddress(){
if(address.value.length>=5) setValid("address","✔ OK");
else setError("address","❌ Too short");
}

/* CITY */
function validateCity(){
if(/^[A-Za-z ]{3,}$/.test(city.value)) setValid("city","✔ OK");
else setError("city","❌ Invalid city");
}

/* PINCODE */
function validatePincode(){
if(/^[0-9]{6}$/.test(pincode.value)) setValid("pincode","✔ Valid");
else setError("pincode","❌ Invalid pincode");
}

/* PHONE */
function validatePhone(){
if(/^[0-9]{10}$/.test(phone.value)) setValid("phone","✔ Valid");
else setError("phone","❌ Invalid number");
}

/* 🔥 AUTO CITY (BASIC DEMO) */
function autoCity(){
let pin=pincode.value;

if(pin=="600001") city.value="Chennai";
else if(pin=="110001") city.value="Delhi";
else if(pin=="560001") city.value="Bangalore";
}

/* 🔥 FINAL CHECK */
function finalCheck(){
let name = document.getElementById("name").value;
let address = document.getElementById("address").value;
let city = document.getElementById("city").value;
let pincode = document.getElementById("pincode").value;
let phone = document.getElementById("phone").value;
 
if(
!/^[A-Za-z ]{3,}$/.test(name.value) ||
address.value.length<5 ||
!/^[A-Za-z ]{3,}$/.test(city.value) ||
!/^[0-9]{6}$/.test(pincode.value) ||
!/^[0-9]{10}$/.test(phone.value)
){
alert("❌ Please enter valid details");
return false;
}

alert("✅ Order Placed");
return true;
}
</script>

</head>

<body>

<div class="container">

<div class="book-box">
<h3>Your Cart</h3>
<% 
    int total=0;
%>    
<%
for(int i=0; i<books.size(); i++){
int price = prices.get(i);
int quantity = qty.get(i);
int itemTotal = price * quantity;
total += itemTotal ;
%>

<img src="<%=images.get(i)%>" width="80">
<p><%=books.get(i)%></p>
<p>₹<%=price%></p>
<p>Qty: <%=quantity%></p>
<p>Total: ₹<%=itemTotal%></p>
<hr>

<% } %>

<h3>Total ₹ <%=total%></h3>

</div>

<div class="form-box">

<h2>Delivery Details</h2>

<form action="success.jsp" method="post" onsubmit="return finalCheck()">
<!-- NAME -->
<input type="text" id="name" name="name" placeholder="Name"
pattern="[A-Za-z ]{3,}" required oninput="validateName()">
<span id="nameError"></span>

<!-- ADDRESS -->
<input type="text" id="address" name="address" placeholder="Address"
required oninput="validateAddress()">
<span id="addressError"></span>

<!-- CITY -->
<input type="text" id="city" name="city" placeholder="City"
pattern="[A-Za-z ]{3,}" required oninput="validateCity()">
<span id="cityError"></span>

<!-- PINCODE -->
<input type="text" id="pincode" name="pincode" placeholder="Pincode"
pattern="[0-9]{6}" maxlength="6"
oninput="validatePincode(); autoCity();" required>
<span id="pincodeError"></span>

<!-- PHONE -->
<input type="text" id="phone" name="phone" placeholder="Phone"
pattern="[0-9]{10}" maxlength="10"
oninput="validatePhone()" required>
<span id="phoneError"></span>

<h3>Payment Method</h3>

<select id="payment" onchange="showPayment()" required>
<option value="">Select</option>
<option value="COD">Cash on Delivery</option>
<option value="UPI">UPI</option>
<option value="Card">Card</option>
<option value="Net">Net Banking</option>
</select>

<div id="upi" class="payment-box">
<p>UPI ID: readora@upi</p>
</div>

<div id="card" class="payment-box">
<input type="text" placeholder="Card Number">
<input type="text" placeholder="Expiry">
<input type="text" placeholder="CVV">
</div>

<div id="net" class="payment-box">
<select>
<option>SBI</option>
<option>HDFC</option>
<option>ICICI</option>
</select>
</div>

<button type="submit">Place Order</button>

</form>

</div>

</div>

</body>
</html>