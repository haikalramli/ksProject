<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<aside class="sidebar">
    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/calendar" class="logo">
            <i class="bi bi-camera-fill"></i>
            <span>KS.Studio</span>
        </a>
    </div>
    
    <nav class="sidebar-nav">
        <ul>
            <li class="${currentPage == 'calendar' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/calendar">
                    <i class="bi bi-calendar3"></i>
                    <span>Activity Calendar</span>
                </a>
            </li>
            <li class="${currentPage == 'package' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/package">
                    <i class="bi bi-box-seam"></i>
                    <span>Package Management</span>
                </a>
            </li>
            <li class="${currentPage == 'upload' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/upload">
                    <i class="bi bi-cloud-upload"></i>
                    <span>Upload Photo</span>
                </a>
            </li>
            <c:if test="${sessionScope.photographerRole == 'senior'}">
            <li class="${currentPage == 'staff' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/staff">
                    <i class="bi bi-people"></i>
                    <span>Staff Management</span>
                </a>
            </li>
            </c:if>
            <li class="${currentPage == 'settings' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/settings">
                    <i class="bi bi-gear"></i>
                    <span>Account Settings</span>
                </a>
            </li>
            <li class="${currentPage == 'payment' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/payment">
                    <i class="bi bi-credit-card"></i>
                    <span>Verify Payment</span>
                </a>
            </li>
            <li class="${currentPage == 'reports' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/jsp/photographer/reports.jsp">
                    <i class="bi bi-graph-up-arrow"></i>
                    <span>Reports</span>
                </a>
            </li>
        </ul>
    </nav>
    
    <div class="sidebar-footer">
        <div class="user-info">
            <span class="logged-as">Logged in as:</span>
            <span class="user-name">${sessionScope.photographerName}</span>
            <span class="user-role">${sessionScope.photographerRole == 'senior' ? 'Senior (Admin)' : (sessionScope.photographerRole == 'junior' ? 'Junior' : 'Intern')}</span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
            <i class="bi bi-box-arrow-right"></i> Logout
        </a>
    </div>
</aside>
