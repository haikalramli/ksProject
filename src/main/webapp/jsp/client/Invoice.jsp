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
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow" style="border-radius: 15px;">
                    <!-- Invoice Header -->
                    <div class="card-header text-white text-center py-4" style="border-radius: 15px 15px 0 0; background: linear-gradient(135deg, #2f5d50, #1a3a32);">
                        <h2 class="mb-0"><i class="bi bi-receipt"></i> INVOICE</h2>
                        <p class="mb-0">KS.Studio Photography</p>
                    </div>
                    
                    <div class="card-body p-4">
                        <!-- Invoice Info -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h6 class="text-muted">INVOICE TO:</h6>
                                <p class="mb-1"><strong>${sessionScope.clientName}</strong></p>
                                <p class="mb-1">${sessionScope.clientEmail}</p>
                            </div>
                            <div class="col-md-6 text-md-end">
                                <h6 class="text-muted">INVOICE DETAILS:</h6>
                                <p class="mb-1"><strong>Invoice #:</strong> INV-${booking.bookingId}</p>
                                <p class="mb-1"><strong>Booking #:</strong> ${booking.bookingId}</p>
                                <p class="mb-1"><strong>Date:</strong> <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd MMM yyyy"/></p>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <!-- Booking Details -->
                        <h5 class="mb-3"><i class="bi bi-calendar-check"></i> Booking Details</h5>
                        <table class="table table-borderless">
                            <tr>
                                <td class="text-muted" width="40%">Package:</td>
                                <td><strong>${booking.packageName}</strong></td>
                            </tr>
                            <tr>
                                <td class="text-muted">Category:</td>
                                <td>
                                    <span class="badge ${booking.packageCateg == 'Indoor' ? 'bg-info' : 'bg-success'}">${booking.packageCateg}</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="text-muted">Date:</td>
                                <td>${booking.bookDate}</td>
                            </tr>
                            <tr>
                                <td class="text-muted">Time:</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty booking.bookStartTime}">
                                            <fmt:formatDate value="${booking.bookStartTime}" pattern="hh:mm a"/> - 
                                            <fmt:formatDate value="${booking.bookEndTime}" pattern="hh:mm a"/>
                                        </c:when>
                                        <c:otherwise>${booking.bookTime}</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <td class="text-muted">Location:</td>
                                <td>${booking.bookLocation}</td>
                            </tr>
                            <tr>
                                <td class="text-muted">Number of People:</td>
                                <td>${booking.bookPax} persons</td>
                            </tr>
                        </table>
                        
                        <hr>
                        
                        <!-- Payment Summary -->
                        <h5 class="mb-3"><i class="bi bi-credit-card"></i> Payment Summary</h5>
                        <table class="table">
                            <thead class="table-light">
                                <tr>
                                    <th>Description</th>
                                    <th class="text-center">Reference</th>
                                    <th class="text-center">Date</th>
                                    <th class="text-end">Amount</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Package Price</td>
                                    <td class="text-center">-</td>
                                    <td class="text-center">-</td>
                                    <td class="text-end">RM <fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0.00"/></td>
                                </tr>
                                
                                <c:if test="${not empty payment.depoRef}">
                                <tr class="table-success">
                                    <td><i class="bi bi-check-circle text-success"></i> Deposit Payment (30%)</td>
                                    <td class="text-center">${payment.depoRef}</td>
                                    <td class="text-center">
                                        <c:if test="${payment.depoDate != null}">
                                            <fmt:formatDate value="${payment.depoDate}" pattern="dd/MM/yyyy"/>
                                        </c:if>
                                    </td>
                                    <td class="text-end text-success">- RM <fmt:formatNumber value="${booking.totalPrice * 0.3}" pattern="#,##0.00"/></td>
                                </tr>
                                </c:if>
                                
                                <c:if test="${not empty payment.fullRef}">
                                <tr class="table-success">
                                    <td><i class="bi bi-check-circle text-success"></i> Full/Remaining Payment</td>
                                    <td class="text-center">${payment.fullRef}</td>
                                    <td class="text-center">
                                        <c:if test="${payment.fullDate != null}">
                                            <fmt:formatDate value="${payment.fullDate}" pattern="dd/MM/yyyy"/>
                                        </c:if>
                                    </td>
                                    <td class="text-end text-success">- RM <fmt:formatNumber value="${booking.totalPrice * 0.7}" pattern="#,##0.00"/></td>
                                </tr>
                                </c:if>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="3" class="text-end"><strong>Total Paid:</strong></td>
                                    <td class="text-end text-success"><strong>RM <fmt:formatNumber value="${payment.paidAmount}" pattern="#,##0.00"/></strong></td>
                                </tr>
                                <tr>
                                    <td colspan="3" class="text-end"><strong>Remaining Balance:</strong></td>
                                    <td class="text-end ${payment.remAmount > 0 ? 'text-danger' : 'text-success'}">
                                        <strong>RM <fmt:formatNumber value="${payment.remAmount}" pattern="#,##0.00"/></strong>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                        
                        <!-- Payment Status -->
                        <div class="text-center my-4">
                            <c:choose>
                                <c:when test="${payment.payStatus == 'verified' && payment.remAmount <= 0}">
                                    <span class="badge bg-success fs-5 px-4 py-2"><i class="bi bi-check-circle"></i> FULLY PAID</span>
                                </c:when>
                                <c:when test="${payment.payStatus == 'partial'}">
                                    <span class="badge bg-warning text-dark fs-5 px-4 py-2"><i class="bi bi-hourglass-split"></i> PARTIALLY PAID</span>
                                </c:when>
                                <c:when test="${payment.payStatus == 'submitted'}">
                                    <span class="badge bg-info fs-5 px-4 py-2"><i class="bi bi-clock"></i> PENDING VERIFICATION</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary fs-5 px-4 py-2">${payment.payStatus}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Footer -->
                        <div class="text-center text-muted border-top pt-3">
                            <p class="mb-1"><small>Thank you for choosing KS.Studio!</small></p>
                            <p class="mb-0"><small>For inquiries, contact us at: info@ksstudio.com | 019-1234567</small></p>
                        </div>
                    </div>
                </div>
                
                <!-- Action Buttons -->
                <div class="text-center mt-4">
                    <button onclick="window.print()" class="btn btn-primary me-2">
                        <i class="bi bi-printer"></i> Print Invoice
                    </button>
                    <a href="${pageContext.request.contextPath}/BookingController?action=list" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left"></i> Back to Bookings
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<style>
@media print {
    .btn, header, footer, .top-header {
        display: none !important;
    }
    .card {
        box-shadow: none !important;
    }
}
</style>

<jsp:include page="Footer.jsp" />
