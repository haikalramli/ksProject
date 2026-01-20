<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<jsp:include page="Header.jsp" />

<!-- Hero Section -->
<section id="hotel-hero" class="hotel-hero section">
    <div class="container" data-aos="fade-up" data-aos-delay="100">
        <div class="row gy-4 align-items-center">
            <div class="col-lg-6" data-aos="fade-right" data-aos-delay="200">
                <div class="hero-content">
                    <h1>Forget The Hassle, Book Your Perfect Shoot</h1>
                    <p class="lead">We provide everything you need to capture timeless moments. It's time to create memories that last forever.</p>
                    <a href="${pageContext.request.contextPath}/packages" class="btn btn-primary btn-lg mt-3">View Packages</a>
                </div>
            </div>
            <div class="col-lg-6" data-aos="fade-left" data-aos-delay="300">
                <div class="hero-images">
                    <div class="main-image">
                        <img src="${pageContext.request.contextPath}/assets/img/homepage.PNG" alt="WeddingPic" class="img-fluid rounded">
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Package Cards Section -->
<section id="offer-cards" class="offer-cards section light-background">
    <div class="container section-title" data-aos="fade-up">
        <span class="description-title">Package</span>
        <h2>Package</h2>
        <p>Choose the perfect photography package for your special moments, whether you prefer a cozy indoor session or a stunning outdoor experience.</p>
    </div>

    <div class="container" data-aos="fade-up" data-aos-delay="100">
        <div class="row g-4">
            <div class="col-lg-6">
                <div class="offer-card" data-aos="zoom-in" data-aos-delay="200">
                    <div class="offer-image">
                        <img src="${pageContext.request.contextPath}/assets/img/indoor/HRG1.jpeg" alt="Indoor Package" class="img-fluid">
                    </div>
                    <div class="offer-content">
                        <h2>Indoor</h2>
                        <p>This is our signature indoor package, perfect for solo portraits, couples, and families. In our studio, you'll enjoy comfort, creativity, and professional lighting.</p>
                        <a href="${pageContext.request.contextPath}/BookingController?action=indoor" class="btn-book">Book Now</a>
                    </div>
                </div>
            </div>

            <div class="col-lg-6">
                <div class="offer-card featured" data-aos="zoom-in" data-aos-delay="300">
                    <div class="offer-image">
                        <img src="${pageContext.request.contextPath}/assets/img/outdoor/W2.jpeg" alt="Outdoor Package" class="img-fluid">
                    </div>
                    <div class="offer-content">
                        <h2>Outdoor</h2>
                        <p>This is our signature outdoor package, designed for weddings and events. Celebrate your special day beneath the open sky with a session that captures love and joy.</p>
                        <a href="${pageContext.request.contextPath}/BookingController?action=outdoor" class="btn-book">Book Now</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Why Choose Us Section -->
<section id="features" class="features section">
    <div class="container section-title" data-aos="fade-up">
        <span class="description-title">Why Choose Us</span>
        <h2>Why Choose Us</h2>
    </div>

    <div class="container">
        <div class="row gy-4">
            <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="100">
                <div class="service-item text-center">
                    <i class="bi bi-camera-fill" style="font-size: 3rem; color: var(--accent-color);"></i>
                    <h3>Professional Equipment</h3>
                    <p>We use top-of-the-line cameras and lighting equipment for stunning results.</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="200">
                <div class="service-item text-center">
                    <i class="bi bi-people-fill" style="font-size: 3rem; color: var(--accent-color);"></i>
                    <h3>Experienced Team</h3>
                    <p>Our photographers have years of experience capturing special moments.</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="300">
                <div class="service-item text-center">
                    <i class="bi bi-heart-fill" style="font-size: 3rem; color: var(--accent-color);"></i>
                    <h3>Passion for Photography</h3>
                    <p>We love what we do, and it shows in every photo we take.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="Footer.jsp" />
