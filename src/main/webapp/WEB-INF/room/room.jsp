<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 
    Document   : room
    Created on : october 1, 2026, 1:35:35 PM
    Author     : Thanhdat
--%>

<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="model.Room"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hotel Rooms</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/litepicker/dist/css/litepicker.css" />
        <script src="https://cdn.jsdelivr.net/npm/litepicker/dist/bundle.js"></script>
        <link href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/general.css" />
        <link rel="stylesheet"
              href="<%= request.getContextPath()%>/assets/css/room.css?v=4" />
    </head>

    <script>
        function filterRooms() {
            const searchInput = document.getElementById("searchRoom");
            const statusInput = document.getElementById("filterRoomStatus");

            const keyword = searchInput.value.trim().toLowerCase();
            const selectedStatus = statusInput.value.toLowerCase();

            const rows = document.querySelectorAll(
                    "#roomTableBody tr.room-row"
                    );

            let visibleCount = 0;

            rows.forEach(function (row) {
                const roomNumber = row.cells[0].textContent.toLowerCase();
                const roomType = row.cells[1].textContent.toLowerCase();
                const status = row.cells[2].textContent.trim().toLowerCase();

                const matchesKeyword =
                        roomNumber.includes(keyword) ||
                        roomType.includes(keyword);

                const matchesStatus =
                        selectedStatus === "" ||
                        status === selectedStatus;

                if (matchesKeyword && matchesStatus) {
                    row.style.display = "";
                    visibleCount++;
                } else {
                    row.style.display = "none";
                }
            });

            const emptyRow = document.getElementById("noMatchingRooms");

            if (emptyRow) {
                emptyRow.style.display =
                        rows.length > 0 && visibleCount === 0
                        ? ""
                        : "none";
            }
        }

        document.getElementById("searchRoom")
                ?.addEventListener("keydown", function (event) {
                    if (event.key === "Enter") {
                        event.preventDefault();
                        filterRooms();
                    }
                });

        document.getElementById("filterRoomStatus")
                ?.addEventListener("change", filterRooms);
    </script>

    <body>
        <div class="body-wrapper">
            <%@include file="../include/header.jsp" %>
            <main>
                <!-- Search bar with destination and date filters -->
                <div class="search-bar">
                    <c:if test="${sessionScope.loggedUser.role == 'admin'}">
                        <a class="btn btn-primary" href="./room?view=create">Create</a>
                    </c:if>
                    <form class="ms-auto w-50 d-flex justify-content-end" method="post" action="<%= request.getContextPath()%>/room?action=search">
                        <div class="w-50 text-center">
                            <input type="text" class="form-control border-3 rounded-4 p-3" id="floatingBookingDate" placeholder="${sessionScope.dates}" name="booking-dates" readonly required>
                        </div>
                        <button class="update-button">Update Search</button>
                    </form>
                </div>

                <!--                 Filter buttons below search bar 
                                <div class="filter-buttons">
                                    <button class="filter-button">All Filters</button>
                                    <button class="filter-button">Price</button>
                                </div>-->


                <!-- List of hotel cards -->

                <c:choose>
                    <%-- Giao diện dành cho Admin --%>

                    <c:when test="${sessionScope.loggedUser.role == 'admin'}">

                        <div class="room-management">

                            <div class="room-management-header">
                                <h1>Room Management</h1>
                            </div>

                            <!-- Search and Filters -->
                            <div class="room-search-bar">

                                <input type="text"
                                       id="searchRoom"
                                       class="form-control"
                                       placeholder="Room number or room type">

                                <select id="filterRoomStatus"
                                        class="form-select">
                                    <option value="">All statuses</option>
                                    <option value="available">Available</option>
                                    <option value="occupied">Occupied</option>
                                    <option value="maintenance">Maintenance</option>
                                </select>

                                <button type="button"
                                        class="room-search-btn"
                                        onclick="filterRooms()">
                                    Search
                                </button>

                                <a href="./room?view=create"
                                   class="room-create-btn">
                                    + Create
                                </a>

                            </div>

                            <!-- Room Table -->
                            <div class="room-table-wrapper">

                                <table class="room-management-table">

                                    <thead>
                                        <tr>
                                            <th>Room</th>
                                            <th>Room Type</th>
                                            <th>Status</th>
                                            <th>Price / Night</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>

                                    <tbody id="roomTableBody">

                                        <c:forEach var="room" items="${rooms}">

                                            <tr class="room-row">

                                                <td class="room-number">
                                                    Room ${room.roomNumber}
                                                </td>

                                                <td class="room-type">
                                                    ${room.roomType.name}
                                                </td>

                                                <td class="room-status-text">
                                                    ${room.status}
                                                </td>

                                                <td class="room-price">
                                                    ${room.roomType.pricePerNight} USD
                                                </td>

                                                <td>
                                                    <div class="room-actions">

                                                        <a class="room-action-details"
                                                           href="./details?roomNumber=${room.roomNumber}">
                                                            Details
                                                        </a>

                                                        <a class="room-action-edit"
                                                           href="./room?view=update&amp;roomNumber=${room.roomNumber}">
                                                            Edit
                                                        </a>

                                                        <a class="room-action-delete"
                                                           href="./room?view=delete&amp;roomNumber=${room.roomNumber}">
                                                            Delete
                                                        </a>

                                                    </div>
                                                </td>

                                            </tr>

                                        </c:forEach>

                                        <tr id="noMatchingRooms"
                                            style="display:none;">
                                            <td colspan="5"
                                                class="text-center p-4">
                                                No matching rooms found.
                                            </td>
                                        </tr>

                                        <c:if test="${empty rooms}">
                                            <tr>
                                                <td colspan="5"
                                                    class="text-center p-4">
                                                    No rooms available.
                                                </td>
                                            </tr>
                                        </c:if>

                                    </tbody>

                                </table>

                            </div>

                        </div>

                    </c:when>


                    <%-- Giao diện khách hàng giữ nguyên --%>
                    <c:otherwise>
                        <div class="hotel-list">
                            <c:forEach var="room" items="${rooms}">
                                <div class="hotel-card w-4">
                                    <a href="./details?roomNumber=${room.roomNumber}">
                                        <img class="img-fluid"
                                             src="${pageContext.request.contextPath}/assets/img/${room.roomType.picture}"
                                             alt="${room.roomType.name}">
                                    </a>

                                    <div class="hotel-details">
                                        <div class="hotel-name">
                                            Room ${room.roomNumber} (${room.roomType.name})
                                        </div>

                                        <div class="hotel-info">
                                            ${room.roomType.description}
                                        </div>

                                        <a href="./details?roomNumber=${room.roomNumber}"
                                           class="details-link">
                                            More details
                                        </a>

                                        <div class="price-rate">
                                            <div class="price">
                                                ${room.roomType.pricePerNight} USD / Night
                                            </div>

                                            <c:if test="${not empty sessionScope.loggedUser}">
                                                <a class="view-button text-decoration-none"
                                                   href="./booking?roomNumber=${room.roomNumber}">
                                                    Book
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>

            </main>
            <c:if test="${requestScope.totalPages > 1}">
                <nav aria-label="Page navigation" class="d-flex w-100 justify-content-center">
                    <ul class="pagination">
                        <li class="page-item ${param["page-index"] == 1 ? "disabled" : ""} rounded-4">
                            <a class="page-link" href="./room?page-index=${param["page-index"] - 1}" tabindex="-1">Previous</a>
                        </li>
                        <c:forEach var = "i" begin = "1" end = "${totalPages}">
                            <li class="page-item" ><a class="page-link ${param["page-index"] == i ? "active" : ""}" href="./room?page-index=${i}">${i}</a></li>
                            </c:forEach>
                        <li class="page-item ${param["page-index"] == requestScope.totalPages ? "disabled" : ""} rounded-4">
                            <a class="page-link" href="./room?page-index=${param["page-index"] + 1}">Next</a>
                        </li>
                    </ul>
                </nav>
            </c:if>

            <%@include file="../include/footer.jsp" %>
        </div>
        <script src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
        <script>
                                            const picker = new Litepicker({
                                                element: document.getElementById('floatingBookingDate'),
                                                singleMode: false, // for date range
                                                numberOfMonths: 2, // show two months side by side
                                                numberOfColumns: 2,
                                                autoApply: true,
                                                format: 'MMM D, YYYY',
                                                tooltipText: {
                                                    one: 'day',
                                                    other: 'days'
                                                },
                                                minDate: new Date()
                                            });
        </script>
    </body>
</html>
