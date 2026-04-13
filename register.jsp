<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Register</title>

<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;600;700&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">

<!-- Font Awesome for Eye Icon -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

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
    margin: 0;
    padding: 0;
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background-image: url('https://www.toptal.com/designers/subtlepatterns/patterns/cream_paper.png');
}

.main-container {
    display: flex;
    width: 900px;
    background: white;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 20px 60px rgba(0,0,0,0.15);
}

.image-side {
    flex: 1;
    background-image: url('https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?ixlib=rb-4.0.3&auto=format&fit=crop&w=680&q=80');
    background-size: cover;
    background-position: center;
    position: relative;
}

.image-side::after {
    content: '';
    position: absolute;
    top: 0; left: 0; width: 100%; height: 100%;
    background: linear-gradient(to right, rgba(0,0,0,0.1), rgba(0,0,0,0.4));
}

.form-side {
    flex: 1;
    padding: 40px 50px;
    display: flex;
    flex-direction: column;
    justify-content: center;
}

h2{
    font-family: 'Cormorant Garamond', serif;
    font-size: 32px;
    color: var(--accent-wine);
    text-align: center;
    margin-bottom: 30px;
}

.input-group {
    margin-bottom: 15px;
    position: relative;
}

label {
    display: block;
    margin-bottom: 5px;
    font-size: 12px;
    text-transform: uppercase;
    color: #888;
    letter-spacing: 1px;
    font-weight: 600;
}

input{
    width: 100%;
    padding: 12px 20px;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-family: 'Lato', sans-serif;
    font-size: 14px;
    transition: all 0.3s;
    box-sizing: border-box;
}

input:focus {
    outline: none;
    border-color: var(--accent-gold);
    box-shadow: 0 0 8px rgba(197, 160, 89, 0.2);
}

/* Password Strength Pattern UI Hint */
input:invalid {
    border-color: #ffcccc; /* Subtle red hint while typing invalid */
}

.password-wrapper {
    position: relative;
}

.toggle-password {
    position: absolute;
    top: 50%;
    right: 15px;
    transform: translateY(-50%);
    cursor: pointer;
    color: #999;
    font-size: 16px;
}

/* Button */
button{
    width: 100%;
    padding: 14px;
    background: var(--accent-wine);
    color: white;
    border: none;
    border-radius: 30px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 2px;
    cursor: pointer;
    transition: all 0.3s;
    margin-top: 15px;
}

button:hover{
    background: #5a2429;
    transform: translateY(-2px);
}

p {
    text-align: center;
    margin-top: 20px;
    font-size: 14px;
}

a {
    color: var(--accent-wine);
    text-decoration: none;
    font-weight: 700;
}

/* Responsive */
@media (max-width: 768px) {
    .main-container {
        flex-direction: column;
        width: 90%;
        height: auto;
        margin: 20px 0;
    }
    .image-side {
        min-height: 200px;
    }
    .form-side {
        padding: 30px;
    }
}
</style>

</head>

<body>

<div class="main-container">
    <!-- Left Side Image -->
    <div class="image-side"></div>

    <!-- Right Side Form -->
    <div class="form-side">
        <h2>Create Account</h2>
        
        <form action="RegisterServlet" method="post">
            
            <div class="input-group">
                <label>Name</label>
                <input type="text" name="name" placeholder="Full Name" required>
            </div>

            <div class="input-group">
                <label>Email</label>
                <input type="email" name="email" placeholder="Email Address" required>
            </div>

            <div class="input-group password-wrapper">
                <label>Password</label>
                <input type="password" id="regPassword" name="password" 
                       pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" 
                       title="Must contain at least one number and one uppercase and lowercase letter, and at least 8 or more characters"
                       placeholder="Password" required>
                <i class="toggle-password fas fa-eye-slash" onclick="toggleRegPassword()"></i>
            </div>

            <div class="input-group">
                <label>Phone</label>
                <input type="text" name="phone" placeholder="Phone Number" required>
            </div>

            <div class="input-group">
                <label>Address</label>
                <input type="text" name="address" placeholder="Address" required>
            </div>

            <button type="submit">Register</button>
        </form>
        
        <p>Already have an account? <a href="login.jsp">Login here</a></p>
    </div>
</div>

<script>
function toggleRegPassword() {
    var x = document.getElementById("regPassword");
    var icon = document.querySelector(".toggle-password");
    if (x.type === "password") {
        x.type = "text";
        icon.classList.remove("fa-eye-slash");
        icon.classList.add("fa-eye");
    } else {
        x.type = "password";
        icon.classList.remove("fa-eye");
        icon.classList.add("fa-eye-slash");
    }
}
</script>

</body>
</html>