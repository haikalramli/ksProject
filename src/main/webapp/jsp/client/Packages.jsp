<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:include page="Header.jsp" />

<!-- Page Title -->
<section class="section light-background">
    <div class="container section-title" data-aos="fade-up">
        <span class="description-title">Our Packages</span>
        <h2>Photography Packages</h2>
        <p>Browse our photography packages created by our professional team. Book your perfect session today!</p>
    </div>
</section>

<!-- Filter Section -->
<section class="section">
    <div class="container">
        <div class="d-flex justify-content-center gap-3 mb-4" data-aos="fade-up">
            <a href="${pageContext.request.contextPath}/packages" class="btn ${empty selectedCategory ? 'btn-primary' : 'btn-outline-primary'}">
                All Packages
            </a>
            <a href="${pageContext.request.contextPath}/packages?category=Indoor" class="btn ${selectedCategory == 'Indoor' ? 'btn-primary' : 'btn-outline-primary'}">
                <i class="bi bi-house"></i> Indoor (${indoorCount})
            </a>
            <a href="${pageContext.request.contextPath}/packages?category=Outdoor" class="btn ${selectedCategory == 'Outdoor' ? 'btn-primary' : 'btn-outline-primary'}">
                <i class="bi bi-tree"></i> Outdoor (${outdoorCount})
            </a>
        </div>
        
        <!-- Package Cards -->
        <div class="row g-4">
            <c:forEach var="pkg" items="${packages}">
            <div class="col-lg-4 col-md-6" data-aos="zoom-in" data-aos-delay="100">
                <div class="card h-100 shadow-sm" style="border-radius: 15px; overflow: hidden;">
                    <div class="card-img-top position-relative" style="height: 200px; background: linear-gradient(135deg, ${pkg.pkgCateg == 'Indoor' ? '#17a2b8, #0d6efd' : '#28a745, #198754'}); display: flex; align-items: center; justify-content: center;">
                        <i class="bi ${pkg.pkgCateg == 'Indoor' ? 'bi-house-fill' : 'bi-tree-fill'}" style="font-size: 4rem; color: rgba(255,255,255,0.3);"></i>
                        <span class="badge bg-light text-dark position-absolute top-0 end-0 m-3">${pkg.pkgCateg}</span>
                    </div>
                    <div class="card-body">
                        <h5 class="card-title" style="font-family: 'Josefin Sans', sans-serif;">${pkg.pkgName}</h5>
                        <p class="text-muted small mb-2">
                            <i class="bi bi-tag"></i> ${pkg.eventType} &bull;
                            <i class="bi bi-clock"></i> ${pkg.pkgDuration} hours
                        </p>
                        <p class="card-text">${pkg.pkgDesc}</p>
                        
                        <c:if test="${pkg.pkgCateg == 'Indoor'}">
                        <div class="small text-muted mb-2">
                            <i class="bi bi-people"></i> Up to ${pkg.numOfPax} pax &bull;
                            <i class="bi bi-image"></i> ${pkg.backgType} background
                        </div>
                        </c:if>
                        
                        <c:if test="${pkg.pkgCateg == 'Outdoor'}">
                        <div class="small text-muted mb-2">
                            <i class="bi bi-geo-alt"></i> ${pkg.location} &bull;
                            <i class="bi bi-truck"></i> +RM ${pkg.distancePricePerKm}/km
                        </div>
                        </c:if>
                        
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <span class="h4 mb-0" style="color: #2f5d50;">
                                RM <fmt:formatNumber value="${pkg.pkgPrice}" pattern="#,##0.00"/>
                            </span>
                            <a href="${pageContext.request.contextPath}/BookingController?action=${pkg.pkgCateg == 'Indoor' ? 'indoor' : 'outdoor'}&pkgId=${pkg.pkgId}" class="btn btn-primary">
                                Book Now
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            </c:forEach>
            
            <c:if test="${empty packages}">
            <div class="col-12 text-center py-5">
                <i class="bi bi-inbox display-1 text-muted"></i>
                <p class="text-muted mt-3">No packages available at the moment. Please check back later.</p>
            </div>
            </c:if>
        </div>
    </div>
</section>

<jsp:include page="Footer.jsp" />
