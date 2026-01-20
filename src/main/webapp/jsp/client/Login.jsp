<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - KS.Studio</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Poppins:wght@300;400;500;600;700&family=Josefin+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2f5d50;
            --secondary-color: #40524d;
            --accent-color: #ff6b6b;
            --client-color: #2f5d50;
            --senior-color: #6f42c1;
            --junior-color: #0d6efd;
        }
        
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Roboto', sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .main-container {
            width: 100%;
            max-width: 1200px;
        }
        
        .back-btn {
            position: fixed;
            top: 20px;
            left: 20px;
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            color: #fff;
            padding: 10px 20px;
            border-radius: 50px;
            text-decoration: none;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .back-btn:hover {
            background: rgba(255,255,255,0.2);
            color: #fff;
        }
        
        .logo-section {
            text-align: center;
            margin-bottom: 50px;
        }
        
        .logo-section h1 {
            font-family: 'Josefin Sans', sans-serif;
            font-size: 3.5rem;
            color: #fff;
            margin-bottom: 10px;
            text-shadow: 2px 2px 10px rgba(0,0,0,0.3);
        }
        
        .logo-section h1 i {
            color: var(--accent-color);
            margin-right: 15px;
        }
        
        .logo-section p {
            font-family: 'Poppins', sans-serif;
            color: rgba(255,255,255,0.7);
            font-size: 1.2rem;
        }
        
        .portal-cards {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
        }
        
        @media (max-width: 992px) {
            .portal-cards {
                grid-template-columns: 1fr;
                max-width: 450px;
                margin: 0 auto;
            }
        }
        
        .portal-card {
            background: #fff;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            transition: all 0.4s ease;
            cursor: pointer;
        }
        
        .portal-card:hover {
            transform: translateY(-15px);
            box-shadow: 0 30px 80px rgba(0,0,0,0.4);
        }
        
        .card-header-custom {
            padding: 40px 30px;
            text-align: center;
            color: #fff;
            position: relative;
            overflow: hidden;
        }
        
        .card-header-custom::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }
        
        .portal-card.client .card-header-custom {
            background: linear-gradient(135deg, #2f5d50, #1a3a32);
        }
        
        .portal-card.senior .card-header-custom {
            background: linear-gradient(135deg, #6f42c1, #4a2c85);
        }
        
        .portal-card.junior .card-header-custom {
            background: linear-gradient(135deg, #0d6efd, #0a58ca);
        }
        
        .card-header-custom i {
            font-size: 3.5rem;
            margin-bottom: 15px;
            display: block;
        }
        
        .card-header-custom h3 {
            font-family: 'Josefin Sans', sans-serif;
            font-size: 1.5rem;
            margin-bottom: 5px;
        }
        
        .card-header-custom span {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        
        .card-body-custom {
            padding: 30px;
        }
        
        .feature-list {
            list-style: none;
            margin-bottom: 25px;
        }
        
        .feature-list li {
            padding: 8px 0;
            color: #666;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .feature-list li i {
            color: var(--primary-color);
            font-size: 1.1rem;
        }
        
        .portal-card.senior .feature-list li i { color: var(--senior-color); }
        .portal-card.junior .feature-list li i { color: var(--junior-color); }
        
        .btn-portal {
            display: block;
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 10px;
            font-family: 'Poppins', sans-serif;
            font-weight: 600;
            font-size: 1rem;
            color: #fff;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
        }
        
        .portal-card.client .btn-portal {
            background: var(--client-color);
        }
        
        .portal-card.client .btn-portal:hover {
            background: #234a40;
        }
        
        .portal-card.senior .btn-portal {
            background: var(--senior-color);
        }
        
        .portal-card.senior .btn-portal:hover {
            background: #5a32a3;
        }
        
        .portal-card.junior .btn-portal {
            background: var(--junior-color);
        }
        
        .portal-card.junior .btn-portal:hover {
            background: #0a58ca;
        }
        
        .footer-text {
            text-align: center;
            margin-top: 40px;
            color: rgba(255,255,255,0.5);
            font-size: 0.9rem;
        }
        
        .footer-text a {
            color: var(--accent-color);
            text-decoration: none;
        }
    </style>
</head>
<body>
    <!-- Back to Home Button -->
    <a href="${pageContext.request.contextPath}/jsp/client/Homepage.jsp" class="back-btn">
        <i class="bi bi-arrow-left"></i> Back to Home
    </a>

    <div class="main-container">
        <div class="logo-section">
            <h1><i class="bi bi-camera-fill"></i>KS.STUDIO</h1>
            <p>Professional Photography Services</p>
        </div>
        
        <div class="portal-cards">
            <!-- Client Portal -->
            <div class="portal-card client" onclick="window.location.href='${pageContext.request.contextPath}/jsp/client/SignIn.jsp'">
                <div class="card-header-custom">
                    <i class="bi bi-person-circle"></i>
                    <h3>Client Portal</h3>
                    <span>Book your photography session</span>
                </div>
                <div class="card-body-custom">
                    <ul class="feature-list">
                        <li><i class="bi bi-check-circle-fill"></i> Browse photography packages</li>
                        <li><i class="bi bi-check-circle-fill"></i> Book indoor & outdoor sessions</li>
                        <li><i class="bi bi-check-circle-fill"></i> Make secure payments</li>
                        <li><i class="bi bi-check-circle-fill"></i> Access your photo gallery</li>
                        <li><i class="bi bi-check-circle-fill"></i> Track booking status</li>
                    </ul>
                    <a href="${pageContext.request.contextPath}/jsp/client/SignIn.jsp" class="btn-portal">
                        <i class="bi bi-box-arrow-in-right"></i> Client Login
                    </a>
                </div>
            </div>
            
            <!-- Senior (Admin) Portal -->
            <div class="portal-card senior" onclick="window.location.href='${pageContext.request.contextPath}/jsp/photographer/login.jsp?type=senior'">
                <div class="card-header-custom">
                    <i class="bi bi-shield-fill-check"></i>
                    <h3>Admin Portal</h3>
                    <span>Senior Photographer / Manager</span>
                </div>
                <div class="card-body-custom">
                    <ul class="feature-list">
                        <li><i class="bi bi-check-circle-fill"></i> Full system access</li>
                        <li><i class="bi bi-check-circle-fill"></i> Manage all packages</li>
                        <li><i class="bi bi-check-circle-fill"></i> Register new staff</li>
                        <li><i class="bi bi-check-circle-fill"></i> Verify client payments</li>
                        <li><i class="bi bi-check-circle-fill"></i> Upload & share photos</li>
                    </ul>
                    <a href="${pageContext.request.contextPath}/jsp/photographer/login.jsp?type=senior" class="btn-portal">
                        <i class="bi bi-box-arrow-in-right"></i> Admin Login
                    </a>
                </div>
            </div>
            
            <!-- Junior/Intern Portal -->
            <div class="portal-card junior" onclick="window.location.href='${pageContext.request.contextPath}/jsp/photographer/login.jsp?type=junior'">
                <div class="card-header-custom">
                    <i class="bi bi-camera-fill"></i>
                    <h3>Photographer Portal</h3>
                    <span>Junior / Intern Staff</span>
                </div>
                <div class="card-body-custom">
                    <ul class="feature-list">
                        <li><i class="bi bi-check-circle-fill"></i> View activity calendar</li>
                        <li><i class="bi bi-check-circle-fill"></i> Manage assigned bookings</li>
                        <li><i class="bi bi-check-circle-fill"></i> Create packages</li>
                        <li><i class="bi bi-check-circle-fill"></i> Upload photos</li>
                        <li><i class="bi bi-check-circle-fill"></i> Update account settings</li>
                    </ul>
                    <a href="${pageContext.request.contextPath}/jsp/photographer/login.jsp?type=junior" class="btn-portal">
                        <i class="bi bi-box-arrow-in-right"></i> Staff Login
                    </a>
                </div>
            </div>
        </div>
        
        <p class="footer-text">
            New client? <a href="${pageContext.request.contextPath}/jsp/client/SignUp.jsp">Create an account</a>
        </p>
    </div>
</body>
</html>
