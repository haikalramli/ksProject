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

<section class="section light-background" style="padding-top: 100px;">
    <div class="container">
        <div class="row">
            <!-- Booking Details -->
            <div class="col-lg-8">
                <div class="card shadow-sm mb-4" style="border-radius: 15px;">
                    <div class="card-header" style="border-radius: 15px 15px 0 0;">
                        <h4 class="mb-0"><i class="bi bi-calendar-check"></i> Booking #${booking.bookingId}</h4>
                    </div>
                    <div class="card-body">
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h5 class="text-muted mb-3">Session Details</h5>
                                <p><i class="bi bi-box-seam text-primary me-2"></i><strong>Package:</strong> ${booking.packageName}</p>
                                <p><i class="bi bi-tag text-primary me-2"></i><strong>Category:</strong> 
                                    <span class="badge ${booking.packageCateg == 'Indoor' ? 'bg-info' : 'bg-success'}">${booking.packageCateg}</span>
                                </p>
                                <p><i class="bi bi-calendar3 text-primary me-2"></i><strong>Date:</strong> ${booking.bookDate}</p>
                                <p><i class="bi bi-clock text-primary me-2"></i><strong>Time:</strong> ${booking.bookTime}</p>
                            </div>
                            <div class="col-md-6">
                                <h5 class="text-muted mb-3">Other Details</h5>
                                <p><i class="bi bi-geo-alt text-primary me-2"></i><strong>Location:</strong> ${booking.bookLocation}</p>
                                <p><i class="bi bi-people text-primary me-2"></i><strong>Pax:</strong> ${booking.bookPax}</p>
                                <p><i class="bi bi-person text-primary me-2"></i><strong>Photographer:</strong> ${booking.photographerName != null ? booking.photographerName : 'To be assigned'}</p>
                                <p><i class="bi bi-info-circle text-primary me-2"></i><strong>Status:</strong>
                                    <span class="badge 
                                        ${booking.bookStatus == 'Confirmed' ? 'bg-success' : 
                                          booking.bookStatus == 'Completed' ? 'bg-info' : 
                                          booking.bookStatus == 'Cancelled' ? 'bg-danger' : 'bg-warning'}">
                                        ${booking.bookStatus}
                                    </span>
                                </p>
                            </div>
                        </div>
                        
                        <c:if test="${not empty booking.bookNotes}">
                        <div class="bg-light p-3 rounded">
                            <h6><i class="bi bi-sticky"></i> Notes</h6>
                            <p class="mb-0">${booking.bookNotes}</p>
                        </div>
                        </c:if>
                    </div>
                </div>
                
                <!-- Photo Download Section -->
                <div class="card shadow-sm" style="border-radius: 15px;">
                    <div class="card-header" style="border-radius: 15px 15px 0 0;">
                        <h4 class="mb-0"><i class="bi bi-images"></i> Your Photos</h4>
                    </div>
                    <div class="card-body text-center">
                        <c:choose>
                            <c:when test="${photoFolder != null}">
                                <!-- Photos Available -->
                                <div class="py-4">
                                    <i class="bi bi-check-circle-fill text-success display-1"></i>
                                    <h4 class="mt-3">Your Photos Are Ready!</h4>
                                    <p class="text-muted">Click the button below to view and download your photos.</p>
                                    
                                    <c:if test="${not empty photoFolder.folderName}">
                                        <p><strong>Folder:</strong> ${photoFolder.folderName}</p>
                                    </c:if>
                                    
                                    <a href="${photoFolder.folderLink}" target="_blank" class="btn btn-success btn-lg mt-3">
                                        <i class="bi bi-cloud-download"></i> Download Photos
                                    </a>
                                    
                                    <c:if test="${not empty photoFolder.folderNotes}">
                                        <div class="alert alert-info mt-4 text-start">
                                            <h6><i class="bi bi-info-circle"></i> Message from Photographer:</h6>
                                            <p class="mb-0">${photoFolder.folderNotes}</p>
                                        </div>
                                    </c:if>
                                </div>
                            </c:when>
                            <c:when test="${!paymentVerified}">
                                <!-- Payment Not Verified -->
                                <div class="py-4">
                                    <i class="bi bi-lock-fill text-warning display-1"></i>
                                    <h4 class="mt-3">Photos Locked</h4>
                                    <p class="text-muted">Your photos will be available once your payment is verified.</p>
                                    <a href="${pageContext.request.contextPath}/clientPayment?bookingId=${booking.bookingId}" class="btn btn-primary mt-2">
                                        <i class="bi bi-credit-card"></i> Complete Payment
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Photos Not Yet Uploaded -->
                                <div class="py-4">
                                    <i class="bi bi-hourglass-split text-secondary display-1"></i>
                                    <h4 class="mt-3">Photos Coming Soon</h4>
                                    <p class="text-muted">Your photos are being edited and will be uploaded soon. We'll notify you when they're ready!</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- Payment Sidebar -->
            <div class="col-lg-4">
                <div class="card shadow-sm sticky-top" style="border-radius: 15px; top: 100px;">
                    <div class="card-header bg-primary text-white" style="border-radius: 15px 15px 0 0;">
                        <h5 class="mb-0"><i class="bi bi-wallet2"></i> Payment Details</h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-borderless mb-0">
                            <tr>
                                <td>Package Price:</td>
                                <td class="text-end">RM <fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0.00"/></td>
                            </tr>
                            <c:if test="${payment != null}">
                            <tr>
                                <td>Amount Paid:</td>
                                <td class="text-end text-success">RM <fmt:formatNumber value="${payment.paidAmount}" pattern="#,##0.00"/></td>
                            </tr>
                            <tr class="border-top">
                                <td><strong>Remaining:</strong></td>
                                <td class="text-end">
                                    <strong class="${payment.remAmount > 0 ? 'text-danger' : 'text-success'}">
                                        RM <fmt:formatNumber value="${payment.remAmount}" pattern="#,##0.00"/>
                                    </strong>
                                </td>
                            </tr>
                            <tr>
                                <td>Status:</td>
                                <td class="text-end">
                                    <span class="badge ${payment.payStatus == 'verified' ? 'bg-success' : (payment.payStatus == 'pending' ? 'bg-warning' : 'bg-danger')}">
                                        ${payment.payStatus == 'verified' ? 'Verified' : (payment.payStatus == 'pending' ? 'Pending' : 'Rejected')}
                                    </span>
                                </td>
                            </tr>
                            </c:if>
                        </table>
                        
                        <c:if test="${payment == null || (payment.payStatus != 'verified' && payment.remAmount > 0)}">
                            <hr>
                            <a href="${pageContext.request.contextPath}/clientPayment?bookingId=${booking.bookingId}" class="btn btn-primary w-100">
                                <i class="bi bi-credit-card"></i> Make Payment
                            </a>
                        </c:if>
                        
                        <hr>
                        <a href="${pageContext.request.contextPath}/BookingController?action=list" class="btn btn-outline-secondary w-100">
                            <i class="bi bi-arrow-left"></i> Back to Bookings
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="Footer.jsp" />
