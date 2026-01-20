<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="dao.BookingDAO" %>
<%@ page import="dao.PaymentDAO" %>
<%@ page import="model.BookingModel" %>
<%@ page import="model.PaymentModel" %>

<%
    // Check if user is logged in (all photographers can access)
    if (session.getAttribute("photographerId") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/photographer/login.jsp");
        return;
    }
    
    // Set current page for sidebar
    request.setAttribute("currentPage", "reports");
    
    // Get date range parameters
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");
    String reportType = request.getParameter("reportType");
    
    // Default to last 30 days if not specified
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Calendar cal = Calendar.getInstance();
    
    Date endDate = cal.getTime();
    cal.add(Calendar.DAY_OF_MONTH, -30);
    Date startDate = cal.getTime();
    
    if (startDateStr != null && !startDateStr.isEmpty()) {
        try {
            startDate = sdf.parse(startDateStr);
        } catch (Exception e) {
            // Use default
        }
    }
    if (endDateStr != null && !endDateStr.isEmpty()) {
        try {
            endDate = sdf.parse(endDateStr);
        } catch (Exception e) {
            // Use default
        }
    }
    
    if (reportType == null || reportType.isEmpty()) {
        reportType = "all";
    }
    
    // Get data from DAOs
    BookingDAO bookingDAO = new BookingDAO();
    PaymentDAO paymentDAO = new PaymentDAO();
    
    List<BookingModel> allBookings = bookingDAO.getAllBookings();
    List<PaymentModel> allPayments = paymentDAO.getAll();
    
    // Filter bookings by date range
    List<BookingModel> filteredBookings = new ArrayList<BookingModel>();
    for (BookingModel b : allBookings) {
        String bookDateStr = b.getBookDate();
        if (bookDateStr != null && !bookDateStr.isEmpty()) {
            try {
                // Parse the booking date string (handle different formats)
                String dateOnly = bookDateStr.length() >= 10 ? bookDateStr.substring(0, 10) : bookDateStr;
                Date bookDate = sdf.parse(dateOnly);
                if (!bookDate.before(startDate) && !bookDate.after(endDate)) {
                    filteredBookings.add(b);
                }
            } catch (Exception e) {
                // Skip if date parsing fails
            }
        }
    }
    
    // Calculate statistics
    int totalBookings = filteredBookings.size();
    double totalRevenue = 0;
    int verifiedPayments = 0;
    int pendingPayments = 0;
    
    // Count by status
    int confirmedBookings = 0;
    int pendingBookings = 0;
    int completedBookings = 0;
    int indoorBookings = 0;
    int outdoorBookings = 0;
    
    // Revenue by day for chart
    Map<String, Double> revenueByDay = new TreeMap<String, Double>();
    Map<String, Integer> bookingsByDay = new TreeMap<String, Integer>();
    
    for (BookingModel b : filteredBookings) {
        totalRevenue += b.getTotalPrice();
        
        String bookDateStr = b.getBookDate();
        if (bookDateStr != null && bookDateStr.length() >= 10) {
            String dateKey = bookDateStr.substring(0, 10);
            Double currentRevenue = revenueByDay.get(dateKey);
            revenueByDay.put(dateKey, (currentRevenue != null ? currentRevenue : 0.0) + b.getTotalPrice());
            
            Integer currentCount = bookingsByDay.get(dateKey);
            bookingsByDay.put(dateKey, (currentCount != null ? currentCount : 0) + 1);
        }
        
        if ("Confirmed".equals(b.getBookStatus())) confirmedBookings++;
        else if ("Pending".equals(b.getBookStatus())) pendingBookings++;
        else if ("Completed".equals(b.getBookStatus())) completedBookings++;
        
        if ("Indoor".equalsIgnoreCase(b.getPackageCateg())) indoorBookings++;
        else if ("Outdoor".equalsIgnoreCase(b.getPackageCateg())) outdoorBookings++;
    }
    
    // Count payments
    for (PaymentModel p : allPayments) {
        String status = p.getPayStatus();
        if ("verified".equals(status) || "completed".equals(status)) {
            verifiedPayments++;
        } else if ("pending".equals(status) || "submitted".equals(status)) {
            pendingPayments++;
        }
    }
    
    // Calculate comparison with previous period
    Calendar prevCal = Calendar.getInstance();
    prevCal.setTime(startDate);
    long daysDiff = (endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24);
    prevCal.add(Calendar.DAY_OF_MONTH, (int) -daysDiff);
    Date prevStartDate = prevCal.getTime();
    
    int prevBookings = 0;
    double prevRevenue = 0;
    for (BookingModel b : allBookings) {
        String bookDateStr = b.getBookDate();
        if (bookDateStr != null && !bookDateStr.isEmpty()) {
            try {
                String dateOnly = bookDateStr.length() >= 10 ? bookDateStr.substring(0, 10) : bookDateStr;
                Date bookDate = sdf.parse(dateOnly);
                if (!bookDate.before(prevStartDate) && bookDate.before(startDate)) {
                    prevBookings++;
                    prevRevenue += b.getTotalPrice();
                }
            } catch (Exception e) {
                // Skip if date parsing fails
            }
        }
    }
    
    int bookingChange = totalBookings - prevBookings;
    double revenueChange = totalRevenue - prevRevenue;
    
    // Set attributes for JSP
    request.setAttribute("startDate", sdf.format(startDate));
    request.setAttribute("endDate", sdf.format(endDate));
    request.setAttribute("reportType", reportType);
    request.setAttribute("totalBookings", totalBookings);
    request.setAttribute("totalRevenue", totalRevenue);
    request.setAttribute("verifiedPayments", verifiedPayments);
    request.setAttribute("pendingPayments", pendingPayments);
    request.setAttribute("bookingChange", bookingChange);
    request.setAttribute("revenueChange", revenueChange);
    request.setAttribute("confirmedBookings", confirmedBookings);
    request.setAttribute("pendingBookings", pendingBookings);
    request.setAttribute("completedBookings", completedBookings);
    request.setAttribute("indoorBookings", indoorBookings);
    request.setAttribute("outdoorBookings", outdoorBookings);
    request.setAttribute("filteredBookings", filteredBookings);
    request.setAttribute("revenueByDay", revenueByDay);
    request.setAttribute("bookingsByDay", bookingsByDay);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports & Analytics - KS.Studio</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Poppins:wght@300;400;500;600;700&family=Josefin+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/photographer-style.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .report-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .report-title {
            font-family: 'Josefin Sans', sans-serif;
            font-size: 2rem;
            font-weight: 600;
            color: #1f2937;
        }
        
        .export-buttons {
            display: flex;
            gap: 10px;
        }
        
        .btn-export {
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-export.pdf {
            background: #dc3545;
            color: white;
        }
        
        .btn-export.excel {
            background: #28a745;
            color: white;
        }
        
        .btn-export.print {
            background: #17a2b8;
            color: white;
        }
        
        .btn-export:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .filter-card {
            background: #fff;
            border-radius: 16px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        
        .filter-row {
            display: flex;
            gap: 20px;
            align-items: flex-end;
            flex-wrap: wrap;
        }
        
        .filter-group {
            flex: 1;
            min-width: 200px;
        }
        
        .filter-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #4a5568;
        }
        
        .filter-group input,
        .filter-group select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }
        
        .filter-group input:focus,
        .filter-group select:focus {
            outline: none;
            border-color: #2f5d50;
            box-shadow: 0 0 0 3px rgba(47, 93, 80, 0.1);
        }
        
        .btn-generate {
            background: linear-gradient(135deg, #2f5d50, #1a3a32);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 180px;
        }
        
        .btn-generate:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(47, 93, 80, 0.3);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        
        @media (max-width: 1200px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 576px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
        
        .stat-box {
            background: #fff;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border-left: 4px solid;
            transition: all 0.3s ease;
        }
        
        .stat-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        }
        
        .stat-box.bookings {
            border-left-color: #3b82f6;
        }
        
        .stat-box.revenue {
            border-left-color: #f59e0b;
        }
        
        .stat-box.verified {
            border-left-color: #10b981;
        }
        
        .stat-box.pending {
            border-left-color: #ef4444;
        }
        
        .stat-box .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            margin-bottom: 15px;
        }
        
        .stat-box.bookings .stat-icon {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
        }
        
        .stat-box.revenue .stat-icon {
            background: linear-gradient(135deg, #f59e0b, #d97706);
        }
        
        .stat-box.verified .stat-icon {
            background: linear-gradient(135deg, #10b981, #059669);
        }
        
        .stat-box.pending .stat-icon {
            background: linear-gradient(135deg, #ef4444, #dc2626);
        }
        
        .stat-box .stat-label {
            font-size: 0.9rem;
            color: #6b7280;
            margin-bottom: 5px;
        }
        
        .stat-box .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: #1f2937;
            font-family: 'Poppins', sans-serif;
        }
        
        .stat-box .stat-change {
            font-size: 0.85rem;
            margin-top: 10px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .stat-box .stat-change.positive {
            color: #10b981;
        }
        
        .stat-box .stat-change.negative {
            color: #ef4444;
        }
        
        .chart-container {
            background: #fff;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        
        .chart-title {
            font-family: 'Josefin Sans', sans-serif;
            font-size: 1.2rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .chart-title i {
            color: #2f5d50;
        }
        
        .charts-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }
        
        @media (max-width: 992px) {
            .charts-row {
                grid-template-columns: 1fr;
            }
        }
        
        .no-data-message {
            text-align: center;
            padding: 60px 20px;
            color: #6b7280;
        }
        
        .no-data-message i {
            font-size: 4rem;
            color: #d1d5db;
            margin-bottom: 15px;
        }
        
        .table-container {
            background: #fff;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        
        .table-container .table {
            margin-bottom: 0;
        }
        
        .table-container .table th {
            background: #f8fafc;
            border-bottom: 2px solid #e2e8f0;
            color: #4a5568;
            font-weight: 600;
            padding: 15px;
        }
        
        .table-container .table td {
            padding: 15px;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
        }
        
        .badge-indoor {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
        }
        
        .badge-outdoor {
            background: linear-gradient(135deg, #22c55e, #16a34a);
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />
        
        <main class="main-content">
            <!-- Header -->
            <div class="report-header">
                <h1 class="report-title"><i class="bi bi-graph-up-arrow"></i> Reports & Analytics</h1>
                <div class="export-buttons">
                    <button class="btn-export pdf" onclick="window.print()">
                        <i class="bi bi-file-pdf"></i> Export PDF
                    </button>
                    <button class="btn-export excel" onclick="exportToExcel()">
                        <i class="bi bi-file-excel"></i> Export Excel
                    </button>
                    <button class="btn-export print" onclick="window.print()">
                        <i class="bi bi-printer"></i> Print
                    </button>
                </div>
            </div>
            
            <!-- Filter Section -->
            <div class="filter-card">
                <form method="get" action="">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label>Start Date</label>
                            <input type="date" name="startDate" value="${startDate}">
                        </div>
                        <div class="filter-group">
                            <label>End Date</label>
                            <input type="date" name="endDate" value="${endDate}">
                        </div>
                        <div class="filter-group">
                            <label>Report Type</label>
                            <select name="reportType">
                                <option value="all" ${reportType == 'all' ? 'selected' : ''}>All Reports</option>
                                <option value="bookings" ${reportType == 'bookings' ? 'selected' : ''}>Booking Report</option>
                                <option value="sales" ${reportType == 'sales' ? 'selected' : ''}>Sales Report</option>
                            </select>
                        </div>
                        <button type="submit" class="btn-generate">
                            <i class="bi bi-arrow-repeat"></i> Generate Report
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-box bookings">
                    <div class="stat-icon"><i class="bi bi-calendar-check"></i></div>
                    <div class="stat-label">Total Bookings</div>
                    <div class="stat-value">${totalBookings}</div>
                    <div class="stat-change ${bookingChange >= 0 ? 'positive' : 'negative'}">
                        <i class="bi ${bookingChange >= 0 ? 'bi-arrow-up' : 'bi-arrow-down'}"></i>
                        ${bookingChange >= 0 ? '+' : ''}${bookingChange} from last period
                    </div>
                </div>
                
                <div class="stat-box revenue">
                    <div class="stat-icon"><i class="bi bi-cash-stack"></i></div>
                    <div class="stat-label">Total Revenue</div>
                    <div class="stat-value">RM <fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></div>
                    <div class="stat-change ${revenueChange >= 0 ? 'positive' : 'negative'}">
                        <i class="bi ${revenueChange >= 0 ? 'bi-arrow-up' : 'bi-arrow-down'}"></i>
                        ${revenueChange >= 0 ? '+' : ''}RM <fmt:formatNumber value="${revenueChange}" pattern="#,##0.00"/> from last period
                    </div>
                </div>
                
                <div class="stat-box verified">
                    <div class="stat-icon"><i class="bi bi-check-circle"></i></div>
                    <div class="stat-label">Verified Payments</div>
                    <div class="stat-value">${verifiedPayments}</div>
                    <div class="stat-change positive">
                        <i class="bi bi-check2-all"></i>
                        ${verifiedPayments} of ${verifiedPayments + pendingPayments} payments
                    </div>
                </div>
                
                <div class="stat-box pending">
                    <div class="stat-icon"><i class="bi bi-hourglass-split"></i></div>
                    <div class="stat-label">Pending Payments</div>
                    <div class="stat-value">${pendingPayments}</div>
                    <div class="stat-change">
                        <i class="bi bi-clock-history"></i>
                        Awaiting verification
                    </div>
                </div>
            </div>
            
            <!-- Charts Row -->
            <div class="charts-row">
                <!-- Bookings Trend Chart -->
                <div class="chart-container">
                    <h3 class="chart-title"><i class="bi bi-bar-chart-line"></i> Bookings Trend</h3>
                    <c:choose>
                        <c:when test="${totalBookings > 0}">
                            <canvas id="bookingsChart" height="250"></canvas>
                        </c:when>
                        <c:otherwise>
                            <div class="no-data-message">
                                <i class="bi bi-inbox"></i>
                                <p>No bookings data available</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Sales Revenue Chart -->
                <div class="chart-container">
                    <h3 class="chart-title"><i class="bi bi-currency-dollar"></i> Sales Revenue</h3>
                    <c:choose>
                        <c:when test="${totalRevenue > 0}">
                            <canvas id="revenueChart" height="250"></canvas>
                        </c:when>
                        <c:otherwise>
                            <div class="no-data-message">
                                <i class="bi bi-cash"></i>
                                <p>No revenue data available</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Booking Category Distribution -->
            <div class="charts-row" style="margin-top: 0;">
                <div class="chart-container">
                    <h3 class="chart-title"><i class="bi bi-pie-chart"></i> Booking Categories</h3>
                    <c:choose>
                        <c:when test="${totalBookings > 0}">
                            <canvas id="categoryChart" height="250"></canvas>
                        </c:when>
                        <c:otherwise>
                            <div class="no-data-message">
                                <i class="bi bi-inbox"></i>
                                <p>No data available</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div class="chart-container">
                    <h3 class="chart-title"><i class="bi bi-list-check"></i> Booking Status</h3>
                    <c:choose>
                        <c:when test="${totalBookings > 0}">
                            <canvas id="statusChart" height="250"></canvas>
                        </c:when>
                        <c:otherwise>
                            <div class="no-data-message">
                                <i class="bi bi-inbox"></i>
                                <p>No data available</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Recent Bookings Table -->
            <div class="table-container">
                <h3 class="chart-title"><i class="bi bi-table"></i> Recent Bookings</h3>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Booking ID</th>
                                <th>Client</th>
                                <th>Package</th>
                                <th>Date</th>
                                <th>Amount</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="booking" items="${filteredBookings}" varStatus="loop">
                                <c:if test="${loop.index < 10}">
                                <tr>
                                    <td><strong>#${booking.bookingId}</strong></td>
                                    <td>${booking.clientName}</td>
                                    <td>
                                        ${booking.packageName}<br>
                                        <span class="${booking.packageCateg == 'Indoor' ? 'badge-indoor' : 'badge-outdoor'}">${booking.packageCateg}</span>
                                    </td>
                                    <td>${booking.bookDate}</td>
                                    <td>RM <fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0.00"/></td>
                                    <td>
                                        <span class="badge ${booking.bookStatus == 'Confirmed' ? 'bg-success' : (booking.bookStatus == 'Pending' ? 'bg-warning text-dark' : 'bg-secondary')}">${booking.bookStatus}</span>
                                    </td>
                                </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${empty filteredBookings}">
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">
                                    <i class="bi bi-inbox display-4"></i>
                                    <p class="mt-2">No bookings found for the selected period</p>
                                </td>
                            </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        // Chart data from server
        var bookingsByDay = {};
        var revenueByDay = {};
        
        <c:forEach var="entry" items="${bookingsByDay}">
        bookingsByDay['${entry.key}'] = ${entry.value};
        </c:forEach>
        
        <c:forEach var="entry" items="${revenueByDay}">
        revenueByDay['${entry.key}'] = ${entry.value};
        </c:forEach>
        
        // Initialize charts
        <c:if test="${totalBookings > 0}">
        // Bookings Trend Chart
        var bookingsCtx = document.getElementById('bookingsChart');
        if (bookingsCtx) {
            new Chart(bookingsCtx.getContext('2d'), {
                type: 'bar',
                data: {
                    labels: Object.keys(bookingsByDay).map(function(d) {
                        return new Date(d).toLocaleDateString('en-GB', { day: '2-digit', month: 'short' });
                    }),
                    datasets: [{
                        label: 'Bookings',
                        data: Object.values(bookingsByDay),
                        backgroundColor: 'rgba(59, 130, 246, 0.7)',
                        borderColor: 'rgba(59, 130, 246, 1)',
                        borderWidth: 1,
                        borderRadius: 5
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: { stepSize: 1 }
                        }
                    }
                }
            });
        }
        
        // Revenue Chart
        var revenueCtx = document.getElementById('revenueChart');
        if (revenueCtx) {
            new Chart(revenueCtx.getContext('2d'), {
                type: 'line',
                data: {
                    labels: Object.keys(revenueByDay).map(function(d) {
                        return new Date(d).toLocaleDateString('en-GB', { day: '2-digit', month: 'short' });
                    }),
                    datasets: [{
                        label: 'Revenue (RM)',
                        data: Object.values(revenueByDay),
                        backgroundColor: 'rgba(245, 158, 11, 0.2)',
                        borderColor: 'rgba(245, 158, 11, 1)',
                        borderWidth: 2,
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) { return 'RM ' + value; }
                            }
                        }
                    }
                }
            });
        }
        
        // Category Pie Chart
        var categoryCtx = document.getElementById('categoryChart');
        if (categoryCtx) {
            new Chart(categoryCtx.getContext('2d'), {
                type: 'doughnut',
                data: {
                    labels: ['Indoor', 'Outdoor'],
                    datasets: [{
                        data: [${indoorBookings}, ${outdoorBookings}],
                        backgroundColor: ['rgba(59, 130, 246, 0.8)', 'rgba(34, 197, 94, 0.8)'],
                        borderColor: ['rgba(59, 130, 246, 1)', 'rgba(34, 197, 94, 1)'],
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        }
        
        // Status Pie Chart
        var statusCtx = document.getElementById('statusChart');
        if (statusCtx) {
            new Chart(statusCtx.getContext('2d'), {
                type: 'doughnut',
                data: {
                    labels: ['Confirmed', 'Pending', 'Completed'],
                    datasets: [{
                        data: [${confirmedBookings}, ${pendingBookings}, ${completedBookings}],
                        backgroundColor: ['rgba(16, 185, 129, 0.8)', 'rgba(245, 158, 11, 0.8)', 'rgba(107, 114, 128, 0.8)'],
                        borderColor: ['rgba(16, 185, 129, 1)', 'rgba(245, 158, 11, 1)', 'rgba(107, 114, 128, 1)'],
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        }
        </c:if>
        
        function exportToExcel() {
            alert('Export to Excel functionality would be implemented here with a library like SheetJS');
        }
    </script>
</body>
</html>
