<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Activity Calendar - KS.Studio</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Poppins:wght@300;400;500;600;700&family=Josefin+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/photographer-style.css" rel="stylesheet">
    <style>
        .calendar-container {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        .calendar-header {
            background: linear-gradient(135deg, #2f5d50, #1a3a32);
            color: #fff;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .calendar-title {
            font-family: 'Josefin Sans', sans-serif;
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0;
        }
        .calendar-nav button {
            background: rgba(255,255,255,0.2);
            border: none;
            color: #fff;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
            margin: 0 5px;
        }
        .calendar-nav button:hover {
            background: rgba(255,255,255,0.3);
        }
        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
        }
        .calendar-day-header {
            padding: 15px;
            text-align: center;
            font-weight: 600;
            color: #fff;
            background: #2f5d50;
            font-family: 'Poppins', sans-serif;
            font-size: 0.85rem;
        }
        .calendar-day {
            min-height: 120px;
            padding: 10px;
            border: 1px solid #e2e8f0;
            cursor: pointer;
            transition: all 0.2s ease;
            background: #fff;
            position: relative;
        }
        .calendar-day:hover {
            background: #f7fafc;
        }
        .calendar-day.today {
            background: #e8f5e9;
        }
        .calendar-day.today .day-number {
            background: #2f5d50;
            color: #fff;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .calendar-day.other-month {
            background: #f8f9fa;
            color: #adb5bd;
        }
        .day-number {
            font-weight: 600;
            margin-bottom: 5px;
            font-size: 1rem;
        }
        .booking-card {
            font-size: 0.7rem;
            padding: 4px 8px;
            border-radius: 6px;
            margin-bottom: 4px;
            cursor: pointer;
            transition: transform 0.2s;
            color: #fff;
        }
        .booking-card:hover {
            transform: scale(1.02);
        }
        .booking-card.indoor {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
        }
        .booking-card.outdoor {
            background: linear-gradient(135deg, #22c55e, #16a34a);
        }
        .booking-card .booking-id {
            font-weight: 600;
        }
        .calendar-legend {
            display: flex;
            gap: 25px;
            justify-content: flex-end;
            padding: 15px 20px;
            background: #f8f9fa;
            border-top: 1px solid #e2e8f0;
        }
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
            color: #4a5568;
        }
        .legend-dot {
            width: 16px;
            height: 16px;
            border-radius: 4px;
        }
        .legend-dot.indoor {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
        }
        .legend-dot.outdoor {
            background: linear-gradient(135deg, #22c55e, #16a34a);
        }
        .today-info {
            background: linear-gradient(135deg, #e0f2fe, #bae6fd);
            border-radius: 12px;
            padding: 15px 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: #0369a1;
        }
        .modal-body .info-row {
            display: flex;
            margin-bottom: 12px;
        }
        .modal-body .info-label {
            width: 140px;
            color: #6b7280;
            font-size: 0.9rem;
        }
        .modal-body .info-value {
            flex: 1;
            font-weight: 500;
            color: #1f2937;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />
        
        <main class="main-content">
            <header class="top-header">
                <h1 class="page-title">Activity Calendar</h1>
            </header>
            
            <!-- Today Info -->
            <div class="today-info">
                <i class="bi bi-clock" style="font-size: 1.5rem;"></i>
                <span>Today: <strong><fmt:formatDate value="<%= new java.util.Date() %>" pattern="EEEE, MMMM d, yyyy"/></strong></span>
            </div>
            
            <!-- Calendar -->
            <div class="calendar-container">
                <div class="calendar-header">
                    <div class="calendar-nav">
                        <button onclick="changeMonth(-1)"><i class="bi bi-chevron-left"></i></button>
                    </div>
                    <h2 class="calendar-title" id="calendarTitle">January 2026</h2>
                    <div class="calendar-nav">
                        <button onclick="changeMonth(1)"><i class="bi bi-chevron-right"></i></button>
                    </div>
                </div>
                
                <div class="calendar-grid">
                    <div class="calendar-day-header">Sun</div>
                    <div class="calendar-day-header">Mon</div>
                    <div class="calendar-day-header">Tue</div>
                    <div class="calendar-day-header">Wed</div>
                    <div class="calendar-day-header">Thu</div>
                    <div class="calendar-day-header">Fri</div>
                    <div class="calendar-day-header">Sat</div>
                </div>
                
                <div class="calendar-grid" id="calendarBody">
                    <!-- Calendar days will be rendered here -->
                </div>
                
                <div class="calendar-legend">
                    <div class="legend-item">
                        <div class="legend-dot indoor"></div>
                        <span>Indoor Package</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-dot outdoor"></div>
                        <span>Outdoor Package</span>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Booking Detail Modal -->
    <div class="modal fade" id="bookingModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 16px;">
                <div class="modal-header" style="background: linear-gradient(135deg, #667eea, #5a67d8); color: #fff; border-radius: 16px 16px 0 0;">
                    <h5 class="modal-title" id="modalBookingId">B2001</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <span class="badge" id="modalPackageBadge" style="font-size: 0.9rem; padding: 8px 16px;">Package Name</span>
                    </div>
                    
                    <div class="info-row">
                        <div class="info-label">Date</div>
                        <div class="info-value" id="modalDate">-</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Time</div>
                        <div class="info-value" id="modalTime">-</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Client Name</div>
                        <div class="info-value" id="modalClientName">-</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Phone Number</div>
                        <div class="info-value" id="modalPhone">-</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Number of People</div>
                        <div class="info-value" id="modalPax">-</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Location</div>
                        <div class="info-value" id="modalLocation">-</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Total Amount</div>
                        <div class="info-value" id="modalAmount">-</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Status</div>
                        <div class="info-value">
                            <span class="badge" id="modalStatus">-</span>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Notes</div>
                        <div class="info-value" id="modalNotes">-</div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        // Bookings data from server
        var bookingsData = [];
        <c:forEach var="booking" items="${bookings}">
        bookingsData.push({
            id: ${booking.bookingId},
            date: '${booking.bookDate}'.substring(0, 10),
            startTime: '<fmt:formatDate value="${booking.bookStartTime}" pattern="HH:mm"/>',
            endTime: '<fmt:formatDate value="${booking.bookEndTime}" pattern="HH:mm"/>',
            clientName: '${booking.clientName}',
            clientPhone: '${booking.clientPhone}',
            packageName: '${booking.packageName}',
            category: '${booking.packageCateg}',
            pax: ${booking.bookPax},
            location: '${booking.bookLocation}',
            totalPrice: ${booking.totalPrice},
            status: '${booking.bookStatus}',
            notes: '${booking.bookNotes}'
        });
        </c:forEach>
        
        var currentYear = new Date().getFullYear();
        var currentMonth = new Date().getMonth();
        var today = new Date();
        
        const monthNames = ["January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"];
        
        function renderCalendar() {
            document.getElementById('calendarTitle').textContent = monthNames[currentMonth] + ' ' + currentYear;
            
            var firstDay = new Date(currentYear, currentMonth, 1);
            var lastDay = new Date(currentYear, currentMonth + 1, 0);
            var startDay = firstDay.getDay();
            var totalDays = lastDay.getDate();
            
            var calendarHtml = '';
            var dayCount = 1;
            var nextMonthDay = 1;
            
            // Previous month days
            var prevMonthLastDay = new Date(currentYear, currentMonth, 0).getDate();
            
            for (var week = 0; week < 6; week++) {
                for (var day = 0; day < 7; day++) {
                    var cellDate = '';
                    var dayNumber = '';
                    var isOtherMonth = false;
                    var isToday = false;
                    
                    if (week === 0 && day < startDay) {
                        // Previous month
                        dayNumber = prevMonthLastDay - startDay + day + 1;
                        isOtherMonth = true;
                    } else if (dayCount > totalDays) {
                        // Next month
                        dayNumber = nextMonthDay++;
                        isOtherMonth = true;
                    } else {
                        // Current month
                        dayNumber = dayCount;
                        cellDate = currentYear + '-' + String(currentMonth + 1).padStart(2, '0') + '-' + String(dayCount).padStart(2, '0');
                        
                        if (currentYear === today.getFullYear() && 
                            currentMonth === today.getMonth() && 
                            dayCount === today.getDate()) {
                            isToday = true;
                        }
                        dayCount++;
                    }
                    
                    var classes = 'calendar-day';
                    if (isOtherMonth) classes += ' other-month';
                    if (isToday) classes += ' today';
                    
                    calendarHtml += '<div class="' + classes + '" data-date="' + cellDate + '">';
                    calendarHtml += '<div class="day-number">' + dayNumber + '</div>';
                    
                    // Add bookings for this day
                    if (cellDate) {
                        var dayBookings = bookingsData.filter(function(b) {
                            return b.date === cellDate;
                        });
                        
                        dayBookings.forEach(function(booking) {
                            var categoryClass = booking.category.toLowerCase() === 'indoor' ? 'indoor' : 'outdoor';
                            calendarHtml += '<div class="booking-card ' + categoryClass + '" onclick="showBookingDetail(' + booking.id + ')">';
                            calendarHtml += '<div class="booking-id">B' + booking.id + '</div>';
                            calendarHtml += '<div>' + booking.packageName + '</div>';
                            calendarHtml += '</div>';
                        });
                    }
                    
                    calendarHtml += '</div>';
                }
                
                if (dayCount > totalDays && week >= 4) break;
            }
            
            document.getElementById('calendarBody').innerHTML = calendarHtml;
        }
        
        function changeMonth(delta) {
            currentMonth += delta;
            if (currentMonth > 11) {
                currentMonth = 0;
                currentYear++;
            } else if (currentMonth < 0) {
                currentMonth = 11;
                currentYear--;
            }
            renderCalendar();
        }
        
        function showBookingDetail(bookingId) {
            var booking = bookingsData.find(function(b) { return b.id === bookingId; });
            if (!booking) return;
            
            document.getElementById('modalBookingId').textContent = 'B' + booking.id;
            
            var pkgBadge = document.getElementById('modalPackageBadge');
            pkgBadge.textContent = booking.packageName;
            if (booking.category.toLowerCase() === 'indoor') {
                pkgBadge.style.background = 'linear-gradient(135deg, #3b82f6, #2563eb)';
            } else {
                pkgBadge.style.background = 'linear-gradient(135deg, #22c55e, #16a34a)';
            }
            pkgBadge.style.color = '#fff';
            
            // Format date
            var dateObj = new Date(booking.date);
            var options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
            document.getElementById('modalDate').textContent = dateObj.toLocaleDateString('en-US', options);
            
            document.getElementById('modalTime').textContent = booking.startTime + ' - ' + booking.endTime;
            document.getElementById('modalClientName').textContent = booking.clientName;
            document.getElementById('modalPhone').textContent = booking.clientPhone || '-';
            document.getElementById('modalPax').textContent = '• ' + booking.pax + ' persons';
            document.getElementById('modalLocation').textContent = booking.location;
            document.getElementById('modalAmount').textContent = 'RM ' + booking.totalPrice.toFixed(2);
            document.getElementById('modalNotes').textContent = booking.notes || '-';
            
            var statusBadge = document.getElementById('modalStatus');
            statusBadge.textContent = booking.status;
            statusBadge.className = 'badge';
            if (booking.status === 'Confirmed') {
                statusBadge.classList.add('bg-success');
            } else if (booking.status === 'Pending') {
                statusBadge.classList.add('bg-warning', 'text-dark');
            } else if (booking.status === 'Completed') {
                statusBadge.classList.add('bg-secondary');
            } else {
                statusBadge.classList.add('bg-info');
            }
            
            new bootstrap.Modal(document.getElementById('bookingModal')).show();
        }
        
        // Initialize
        renderCalendar();
    </script>
</body>
</html>
