<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - KS.Studio</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Poppins:wght@300;400;500;600;700&family=Josefin+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2f5d50;
            --accent-color: #d4a574;
        }
        
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #2f5d50 0%, #1a3a32 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .login-container {
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            width: 100%;
            max-width: 450px;
        }
        
        .login-header {
            background: var(--primary-color);
            color: #fff;
            padding: 40px;
            text-align: center;
        }
        
        .login-header h1 {
            font-family: 'Josefin Sans', sans-serif;
            font-size: 2rem;
            margin-bottom: 10px;
        }
        
        .login-header p {
            opacity: 0.8;
            font-size: 0.95rem;
        }
        
        .login-body {
            padding: 40px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
            color: #333;
            margin-bottom: 8px;
            display: block;
        }
        
        .form-control {
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(47, 93, 80, 0.1);
        }
        
        .btn-login {
            background: var(--primary-color);
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 14px;
            font-size: 1rem;
            font-weight: 600;
            width: 100%;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
        }
        
        .btn-login:hover {
            background: #234a40;
            transform: translateY(-2px);
        }
        
        .divider {
            text-align: center;
            margin: 25px 0;
            color: #999;
            position: relative;
        }
        
        .divider::before, .divider::after {
            content: '';
            position: absolute;
            top: 50%;
            width: 40%;
            height: 1px;
            background: #e0e0e0;
        }
        
        .divider::before { left: 0; }
        .divider::after { right: 0; }
        
        .signup-link {
            text-align: center;
        }
        
        .signup-link a {
            color: var(--primary-color);
            font-weight: 600;
            text-decoration: none;
        }
        
        .signup-link a:hover {
            text-decoration: underline;
        }
        
        .alert {
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #666;
            text-decoration: none;
        }
        
        .back-link:hover {
            color: var(--primary-color);
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1><i class="bi bi-camera"></i> KS.STUDIO</h1>
            <p>Welcome back! Sign in to continue</p>
        </div>
        
        <div class="login-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/SignInController" method="post">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" class="form-control" id="email" name="email" 
                           placeholder="Enter your email" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" class="form-control" id="password" name="password" 
                           placeholder="Enter your password" required>
                </div>
                
                <button type="submit" class="btn-login">Sign In</button>
            </form>
            
            <div class="divider">or</div>
            
            <div class="signup-link">
                <p>Don't have an account? <a href="${pageContext.request.contextPath}/jsp/client/SignUp.jsp">Sign Up</a></p>
            </div>
            
            <a href="${pageContext.request.contextPath}/" class="back-link">
                <i class="bi bi-arrow-left"></i> Back to Home
            </a>
        </div>
    </div>
</body>
</html>
