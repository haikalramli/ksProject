<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
    if (session.getAttribute("clientID") == null) {
        response.sendRedirect("SignIn.jsp");
        return;
    }
%>

<jsp:include page="Header.jsp" />

<section class="section light-background" style="padding-top: 100px; min-height: 80vh;">
    <div class="container">
        <div class="section-title" data-aos="fade-up">
            <span class="description-title">My Photos</span>
            <h2>Photo Gallery</h2>
            <p>Your photos from booking #${booking.bookingId}</p>
        </div>
        
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Payment Not Verified -->
                <c:if test="${!paymentVerified}">
                    <div class="card shadow-sm text-center py-5" style="border-radius: 15px;">
                        <div class="card-body">
                            <i class="bi bi-folder text-info" style="font-size: 5rem;"></i>
                            <h4 class="mt-3">Your Folder Link Is Not Ready Yet</h4>
                            <p class="text-muted mb-4">Your photos will be available once your payment is verified.</p>
                            <a href="${pageContext.request.contextPath}/ClientPaymentController?bookingId=${booking.bookingId}" class="btn btn-primary">
                                <i class="bi bi-credit-card"></i> Make Payment
                            </a>
                        </div>
                    </div>
                </c:if>
                
                <!-- Payment Verified - Show Photos -->
                <c:if test="${paymentVerified}">
                    <c:choose>
                        <c:when test="${photo != null && not empty photo.folderLink}">
                            <div class="card shadow-sm" style="border-radius: 15px; overflow: hidden;">
                                <div class="card-header text-white" style="background: linear-gradient(135deg, #2f5d50, #1a3a32);">
                                    <h5 class="mb-0"><i class="bi bi-images"></i> ${photo.folderName}</h5>
                                </div>
                                <div class="card-body text-center py-5">
                                    <i class="bi bi-folder2-open text-primary" style="font-size: 5rem;"></i>
                                    <h4 class="mt-3">Your Photos Are Ready!</h4>
                                    <p class="text-muted">Click the button below to access your photo folder.</p>
                                    
                                    <a href="${photo.folderLink}" target="_blank" class="btn btn-success btn-lg mt-3">
                                        <i class="bi bi-cloud-download"></i> Open Photo Folder
                                    </a>
                                    
                                    <div class="mt-4 text-start">
                                        <small class="text-muted">
                                            <i class="bi bi-calendar"></i> Uploaded: <fmt:formatDate value="${photo.folderUpload}" pattern="dd MMM yyyy"/>
                                        </small>
                                    </div>
                                </div>
                                
                                <c:if test="${not empty photo.notesForClient}">
                                <div class="card-footer bg-light">
                                    <h6><i class="bi bi-chat-left-text"></i> Notes from Photographer:</h6>
                                    <p class="mb-0">${photo.notesForClient}</p>
                                </div>
                                </c:if>
                            </div>
                        </c:when>
                        
                        <c:otherwise>
                            <div class="card shadow-sm text-center py-5" style="border-radius: 15px;">
                                <div class="card-body">
                                    <i class="bi bi-folder text-info" style="font-size: 5rem;"></i>
                                    <h4 class="mt-3">Your Folder Link Is Not Yet Ready</h4>
                                    <p class="text-muted mb-4">
                                        Your payment has been verified successfully! <br>
                                        Our photographer is currently uploading your photos. 
                                    </p>
                                    <div class="alert alert-info d-inline-block">
                                        <i class="bi bi-info-circle"></i> 
                                        Please check back later or contact us for updates.
                                    </div>
                                    <p class="mt-3">
                                        <small class="text-muted">
                                            <i class="bi bi-telephone"></i> Contact: 019-1234567 | 
                                            <i class="bi bi-envelope"></i> info@ksstudio.com
                                        </small>
                                    </p>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>
                
                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/BookingController?action=list" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left"></i> Back to My Bookings
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="Footer.jsp" />
