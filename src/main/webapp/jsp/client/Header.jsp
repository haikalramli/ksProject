<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>KS.Studio - Photography</title>
    
    <!-- Favicons -->
    <link href="${pageContext.request.contextPath}/assets/img/favicon.png" rel="icon">
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Poppins:wght@300;400;500;600;700&family=Josefin+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Vendor CSS Files -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">
    
    <!-- Main CSS File -->
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    
    <!-- Custom Navigation Styles -->
    <style>
        /* Custom navigation button styles matching the reference design */
        .navmenu .nav-home {
            background-color: #2f5d50 !important;
            color: #fff !important;
            padding: 10px 25px !important;
            border-radius: 50px !important;
            margin-right: 5px;
        }
        
        .navmenu .nav-home:hover {
            background-color: #234a40 !important;
        }
        
        .navmenu .nav-login {
            background: transparent !important;
            color: #ff6b6b !important;
            border: 2px solid #ff6b6b !important;
            padding: 8px 20px !important;
            border-radius: 50px !important;
            transition: all 0.3s ease !important;
        }
        
        .navmenu .nav-login:hover {
            background-color: #ff6b6b !important;
            color: #fff !important;
        }
        
        .navmenu .nav-login i {
            margin-right: 5px;
        }
        
        /* Mobile responsive adjustments */
        @media (max-width: 1199px) {
            .navmenu .nav-home,
            .navmenu .nav-login {
                display: inline-block;
                margin: 10px 15px;
            }
        }
    </style>
</head>

<body class="index-page">

<header id="header" class="header sticky-top">

    <div class="topbar d-flex align-items-center dark-background">
        <div class="container d-flex justify-content-center justify-content-md-between">
            <div class="contact-info d-flex align-items-center">
                <i class="bi bi-envelope d-flex align-items-center">
                    <a href="mailto:kspictures29@gmail.com">kspictures29@gmail.com</a>
                </i>
                <i class="bi bi-phone d-flex align-items-center ms-4">
                    <span>+60136900868</span>
                </i>
            </div>
            <div class="social-links d-none d-md-flex align-items-center">
                <a href="https://www.tiktok.com/@ks_studio0" class="tiktok"><i class="bi bi-tiktok"></i></a>
                <a href="https://www.instagram.com/kspictures.co" class="instagram"><i class="bi bi-instagram"></i></a>
            </div>
        </div>
    </div>

    <div class="branding d-flex align-items-center">
        <div class="container position-relative d-flex align-items-center justify-content-between">
            <a href="${pageContext.request.contextPath}/jsp/client/Homepage.jsp" class="logo d-flex align-items-center">
                <img src="${pageContext.request.contextPath}/assets/img/person/logoks.png" alt="logo">
                <h1 class="sitename">KS.STUDIO</h1>
            </a>

            <nav id="navmenu" class="navmenu">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/jsp/client/Homepage.jsp" class="nav-home">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/packages">Package</a></li>
                    <li><a href="${pageContext.request.contextPath}/BookingController?action=list">Booking</a></li>

                    <c:choose>
                        <c:when test="${not empty sessionScope.clientName}">
                            <li class="dropdown">
                                <a href="#">
                                    <span>Hi, ${fn:split(sessionScope.clientName, ' ')[0]}</span>
                                    <i class="bi bi-chevron-down toggle-dropdown"></i>
                                </a>
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/jsp/client/ViewAccount.jsp">Manage Account</a></li>
                                    <li><a href="${pageContext.request.contextPath}/LogoutController">Logout</a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li><a href="${pageContext.request.contextPath}/jsp/client/Login.jsp" class="nav-login"><i class="bi bi-box-arrow-in-right"></i> Login</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
                <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
            </nav>
        </div>
    </div>

</header>

<main class="main">
