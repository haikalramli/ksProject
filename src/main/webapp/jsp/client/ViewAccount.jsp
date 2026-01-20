<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    if (session.getAttribute("clientID") == null) {
        response.sendRedirect("SignIn.jsp");
        return;
    }
%>

<jsp:include page="Header.jsp" />

<section class="section light-background" style="padding-top: 100px;">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-sm" style="border-radius: 15px;">
                    <div class="card-header bg-primary text-white text-center py-4" style="border-radius: 15px 15px 0 0;">
                        <i class="bi bi-person-circle display-4"></i>
                        <h3 class="mt-2 mb-0">My Account</h3>
                    </div>
                    <div class="card-body p-4">
                        <c:if test="${not empty success}">
                            <div class="alert alert-success">${success}</div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        
                        <div class="row mb-4">
                            <div class="col-md-4 text-muted">Name:</div>
                            <div class="col-md-8"><strong>${sessionScope.clientName}</strong></div>
                        </div>
                        <div class="row mb-4">
                            <div class="col-md-4 text-muted">Email:</div>
                            <div class="col-md-8">${sessionScope.clientEmail}</div>
                        </div>
                        
                        <hr>
                        
                        <div class="d-flex gap-3 justify-content-center mt-4">
                            <a href="${pageContext.request.contextPath}/ClientProfileController" class="btn btn-outline-primary">
                                <i class="bi bi-pencil"></i> Edit Profile
                            </a>
                            <a href="${pageContext.request.contextPath}/BookingController?action=list" class="btn btn-primary">
                                <i class="bi bi-calendar3"></i> My Bookings
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="Footer.jsp" />
