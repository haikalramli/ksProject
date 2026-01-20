<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
</main>

<footer id="footer" class="footer dark-background">
    <div class="container">
        <div class="row gy-4">
            <div class="col-lg-4 col-md-6">
                <div class="footer-about">
                    <a href="${pageContext.request.contextPath}/jsp/client/Homepage.jsp" class="logo d-flex align-items-center">
                        <span class="sitename">KS.Studio</span>
                    </a>
                    <p>Professional photography services for all your special moments. We capture memories that last forever.</p>
                    <div class="social-links d-flex mt-4">
                        <a href="https://www.tiktok.com/@ks_studio0"><i class="bi bi-tiktok"></i></a>
                        <a href="https://www.instagram.com/kspictures.co"><i class="bi bi-instagram"></i></a>
                    </div>
                </div>
            </div>

            <div class="col-lg-2 col-md-3 footer-links">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/jsp/client/Homepage.jsp">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/packages">Packages</a></li>
                    <li><a href="${pageContext.request.contextPath}/BookingController?action=list">My Bookings</a></li>
                </ul>
            </div>

            <div class="col-lg-2 col-md-3 footer-links">
                <h4>Services</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/packages?category=Indoor">Indoor Photography</a></li>
                    <li><a href="${pageContext.request.contextPath}/packages?category=Outdoor">Outdoor Photography</a></li>
                    <li><a href="#">Wedding Photography</a></li>
                </ul>
            </div>

            <div class="col-lg-4 col-md-6 footer-contact">
                <h4>Contact Us</h4>
                <p>Kuala Lumpur, Malaysia</p>
                <p class="mt-2">
                    <strong>Phone:</strong> <span>+60136900868</span><br>
                    <strong>Email:</strong> <span>kspictures29@gmail.com</span><br>
                </p>
            </div>
        </div>
    </div>

    <div class="container copyright text-center mt-4">
        <p>© <span>2026</span> <strong class="sitename">KS.Studio</strong>. All Rights Reserved.</p>
    </div>
</footer>

<!-- Scroll Top -->
<a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center">
    <i class="bi bi-arrow-up-short"></i>
</a>

<!-- Vendor JS Files -->
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/glightbox/js/glightbox.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/swiper/swiper-bundle.min.js"></script>

<!-- Main JS File -->
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

</body>
</html>
