<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Booking History</title>

    <link
        href="<%= request.getContextPath()%>/assets/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        href="<%= request.getContextPath()%>/assets/css/general.css"
        rel="stylesheet">

</head>

<body>

<div class="body-wrapper">

    <%@include file="/WEB-INF/include/header.jsp" %>

    <main>

        <div class="container py-4">


            <!-- ================================================= -->
            <!-- PAGE TITLE                                        -->
            <!-- ================================================= -->

            <c:choose>

                <c:when test="${loggedUser.role == 'admin'
                                || loggedUser.role == 'staff'}">

                    <h2 class="fw-bold text-center mb-4">

                        Customer
                        (ID: ${requestScope.historyCustomerId})
                        Booking History

                    </h2>

                </c:when>


                <c:otherwise>

                    <h2 class="fw-bold text-center mb-4">

                        Your Booking History

                    </h2>

                </c:otherwise>

            </c:choose>


            <!-- ================================================= -->
            <!-- MESSAGES                                          -->
            <!-- ================================================= -->

            <c:if test="${param.message == 'cancel-success'}">

                <div class="alert alert-success text-center">

                    Booking cancelled successfully.

                </div>

            </c:if>


            <c:if test="${param.message == 'cannot-cancel'}">

                <div class="alert alert-danger text-center">

                    This booking cannot be cancelled.

                    Cancellation is allowed only for eligible
                    pending/confirmed bookings at least
                    24 hours before check-in.

                </div>

            </c:if>


            <c:if test="${param.message == 'invalid-booking'}">

                <div class="alert alert-danger text-center">

                    Invalid booking.

                </div>

            </c:if>


            <c:if test="${param.message == 'booking-not-found'}">

                <div class="alert alert-danger text-center">

                    Booking not found.

                </div>

            </c:if>


            <c:if test="${param.message == 'payment-success'}">

                <div class="alert alert-success text-center">

                    Payment completed successfully.

                </div>

            </c:if>


            <c:if test="${param.message == 'already-paid'}">

                <div class="alert alert-info text-center">

                    This booking is already fully paid.

                </div>

            </c:if>


            <c:if test="${param.message == 'cannot-pay'}">

                <div class="alert alert-danger text-center">

                    This booking cannot be paid in its current status.

                </div>

            </c:if>


            <!-- ================================================= -->
            <!-- BOOKING LIST                                      -->
            <!-- ================================================= -->

            <c:choose>

                <c:when test="${not empty requestScope.bookings}">

                    <div class="d-flex flex-column gap-3">


                        <c:forEach
                            var="booking"
                            items="${requestScope.bookings}">


                            <div class="shadow-sm rounded-4 p-4 bg-white">


                                <!-- Booking Header -->

                                <div class="d-flex
                                            flex-column
                                            flex-md-row
                                            justify-content-between
                                            gap-3">


                                    <div>


                                        <h4 class="fw-semibold mb-3">

                                            Booking #${booking.id}

                                        </h4>


                                        <p class="mb-1">

                                            <strong>Status:</strong>


                                            <c:choose>

                                                <c:when test="${booking.status == 'pending'}">

                                                    <span class="badge bg-warning text-dark">

                                                        Pending

                                                    </span>

                                                </c:when>


                                                <c:when test="${booking.status == 'confirmed'}">

                                                    <span class="badge bg-primary">

                                                        Confirmed

                                                    </span>

                                                </c:when>


                                                <c:when test="${booking.status == 'cancelled'}">

                                                    <span class="badge bg-danger">

                                                        Cancelled

                                                    </span>

                                                </c:when>


                                                <c:when test="${booking.status == 'checked_in'}">

                                                    <span class="badge bg-info text-dark">

                                                        Checked In

                                                    </span>

                                                </c:when>


                                                <c:when test="${booking.status == 'checked_out'}">

                                                    <span class="badge bg-secondary">

                                                        Checked Out

                                                    </span>

                                                </c:when>


                                                <c:when test="${booking.status == 'completed'}">

                                                    <span class="badge bg-success">

                                                        Completed

                                                    </span>

                                                </c:when>


                                                <c:otherwise>

                                                    <span class="badge bg-secondary">

                                                        ${booking.status}

                                                    </span>

                                                </c:otherwise>

                                            </c:choose>

                                        </p>


                                        <p class="mb-1">

                                            <strong>

                                                Booking Date:

                                            </strong>

                                            ${booking.bookingDate}

                                        </p>


                                        <c:if test="${not empty booking.specialRequest}">

                                            <p class="mb-1">

                                                <strong>

                                                    Special Request:

                                                </strong>

                                                ${booking.specialRequest}

                                            </p>

                                        </c:if>


                                        <c:if test="${booking.status == 'cancelled'}">

                                            <p class="mb-1">

                                                <strong>

                                                    Cancellation Date:

                                                </strong>

                                                ${booking.cancellationDate}

                                            </p>


                                            <c:if test="${not empty booking.cancellationReason}">

                                                <p class="mb-1">

                                                    <strong>

                                                        Cancellation Reason:

                                                    </strong>

                                                    ${booking.cancellationReason}

                                                </p>

                                            </c:if>

                                        </c:if>


                                    </div>


                                    <!-- ================================= -->
                                    <!-- PRICE / PAYMENT SUMMARY           -->
                                    <!-- ================================= -->

                                    <div class="text-md-end">


                                        <p class="fw-bold fs-5 text-success mb-2">

                                            Total:
                                            $${booking.totalPrice}

                                        </p>


                                        <c:set
                                            var="paidAmount"
                                            value="${paidAmountMap[booking.id]}" />


                                        <c:set
                                            var="remainingAmount"
                                            value="${remainingAmountMap[booking.id]}" />


                                        <c:choose>


                                            <%-- No payment --%>

                                            <c:when test="${empty paidAmount || paidAmount <= 0}">

                                                <span class="badge
                                                             bg-warning
                                                             text-dark
                                                             fs-6
                                                             px-3
                                                             py-2">

                                                    Unpaid

                                                </span>


                                                <p class="mt-2 mb-0">

                                                    Paid: $0.00

                                                </p>


                                                <p class="mb-0">

                                                    Remaining:
                                                    $${booking.totalPrice}

                                                </p>

                                            </c:when>


                                            <%-- Fully paid --%>

                                            <c:when test="${remainingAmount <= 0}">

                                                <span class="badge
                                                             bg-success
                                                             fs-6
                                                             px-3
                                                             py-2">

                                                    Fully Paid

                                                </span>


                                                <p class="mt-2 mb-0">

                                                    Paid:
                                                    $${paidAmount}

                                                </p>


                                                <p class="mb-0">

                                                    Remaining:
                                                    $0.00

                                                </p>

                                            </c:when>


                                            <%-- Partial payment --%>

                                            <c:otherwise>

                                                <span class="badge
                                                             bg-info
                                                             text-dark
                                                             fs-6
                                                             px-3
                                                             py-2">

                                                    Partially Paid

                                                </span>


                                                <p class="mt-2 mb-0">

                                                    Paid:
                                                    $${paidAmount}

                                                </p>


                                                <p class="mb-0">

                                                    Remaining:
                                                    $${remainingAmount}

                                                </p>

                                            </c:otherwise>


                                        </c:choose>


                                    </div>


                                </div>


                                <hr>


                                <!-- ================================= -->
                                <!-- BOOKING DETAILS                   -->
                                <!-- ================================= -->

                                <h5 class="mb-3">

                                    Room Details

                                </h5>


                                <c:forEach
                                    var="detail"
                                    items="${booking.details}">


                                    <div class="border rounded-3 p-3 mb-3">


                                        <p class="mb-1">

                                            <strong>
                                                Room:
                                            </strong>

                                            <a
                                                href="${pageContext.request.contextPath}/details?roomNumber=${detail.roomNumber}">

                                                #${detail.roomNumber}

                                            </a>

                                        </p>


                                        <p class="mb-1">

                                            <strong>
                                                Check-in:
                                            </strong>

                                            ${detail.checkInDate}

                                        </p>


                                        <p class="mb-1">

                                            <strong>
                                                Check-out:
                                            </strong>

                                            ${detail.checkOutDate}

                                        </p>


                                        <p class="mb-1">

                                            <strong>
                                                Guest Count:
                                            </strong>

                                            ${detail.guestCount}

                                        </p>


                                        <p class="mb-1">

                                            <strong>
                                                Price Per Night:
                                            </strong>

                                            $${detail.pricePerNight}

                                        </p>


                                        <c:if test="${not empty detail.specialRequest}">

                                            <p class="mb-0">

                                                <strong>
                                                    Room Request:
                                                </strong>

                                                ${detail.specialRequest}

                                            </p>

                                        </c:if>


                                    </div>


                                </c:forEach>


                                <!-- ================================= -->
                                <!-- CUSTOMER ACTIONS                 -->
                                <!-- ================================= -->

                                <c:if test="${loggedUser.role == 'customer'}">


                                    <div class="d-flex
                                                flex-wrap
                                                justify-content-end
                                                gap-2
                                                mt-3">


                                        <!-- ================================= -->
                                        <!-- PAY / PAY REMAINING               -->
                                        <!-- ================================= -->

                                        <c:if test="${(booking.status == 'pending'
                                                        || booking.status == 'confirmed')
                                                       && remainingAmountMap[booking.id] > 0}">


                                            <form
                                                action="${pageContext.request.contextPath}/payment"
                                                method="get">


                                                <input
                                                    type="hidden"
                                                    name="bookingId"
                                                    value="${booking.id}">


                                                <button
                                                    class="btn btn-success btn-sm"
                                                    type="submit">


                                                    <c:choose>


                                                        <c:when test="${paidAmountMap[booking.id] > 0}">

                                                            Pay Remaining

                                                        </c:when>


                                                        <c:otherwise>

                                                            Pay

                                                        </c:otherwise>


                                                    </c:choose>


                                                </button>


                                            </form>


                                        </c:if>


                                        <!-- ================================= -->
                                        <!-- CANCEL                            -->
                                        <!-- ================================= -->

                                        <c:if test="${cancellableMap[booking.id]}">


                                            <a
                                                href="${pageContext.request.contextPath}/history/cancel-booking?id=${booking.id}"
                                                class="btn btn-danger btn-sm">

                                                Cancel

                                            </a>


                                        </c:if>


                                        <!-- ================================= -->
                                        <!-- REVIEW                            -->
                                        <!-- ================================= -->

                                        <c:if test="${booking.status == 'completed'
                                                     && !reviewedMap[booking.id]
                                                     && not empty booking.details}">


                                            <form
                                                action="${pageContext.request.contextPath}/review"
                                                method="post"
                                                class="d-flex
                                                       flex-wrap
                                                       gap-1
                                                       align-items-center">


                                                <input
                                                    type="hidden"
                                                    name="booking-id"
                                                    value="${booking.id}">


                                                <input
                                                    type="hidden"
                                                    name="room-number"
                                                    value="${booking.details[0].roomNumber}">


                                                <select
                                                    name="star"
                                                    class="form-select form-select-sm"
                                                    style="width:auto"
                                                    required>


                                                    <option value="">

                                                        Rating

                                                    </option>


                                                    <option value="5">
                                                        5
                                                    </option>

                                                    <option value="4">
                                                        4
                                                    </option>

                                                    <option value="3">
                                                        3
                                                    </option>

                                                    <option value="2">
                                                        2
                                                    </option>

                                                    <option value="1">
                                                        1
                                                    </option>


                                                </select>


                                                <input
                                                    type="text"
                                                    name="comment"
                                                    maxlength="1000"
                                                    class="form-control form-control-sm"
                                                    placeholder="Feedback"
                                                    style="max-width:220px">


                                                <button
                                                    class="btn btn-outline-primary btn-sm"
                                                    type="submit">

                                                    Review

                                                </button>


                                            </form>


                                        </c:if>


                                    </div>


                                </c:if>


                            </div>


                        </c:forEach>


                    </div>


                    <!-- ================================================= -->
                    <!-- PAGINATION                                        -->
                    <!-- ================================================= -->

                    <c:if test="${totalPages > 1}">


                        <nav
                            aria-label="Booking history pagination"
                            class="d-flex
                                   justify-content-center
                                   mt-4">


                            <ul class="pagination">


                                <!-- Previous -->

                                <li
                                    class="page-item
                                           ${currentPage == 1
                                             ? 'disabled'
                                             : ''}">


                                    <a
                                        class="page-link"
                                        href="${pageContext.request.contextPath}/history?id=${requestScope.historyCustomerId}&view=bookings&page=${currentPage - 1}">

                                        Previous

                                    </a>


                                </li>


                                <!-- Pages -->

                                <c:forEach
                                    var="i"
                                    begin="1"
                                    end="${totalPages}">


                                    <li
                                        class="page-item
                                               ${currentPage == i
                                                 ? 'active'
                                                 : ''}">


                                        <a
                                            class="page-link"
                                            href="${pageContext.request.contextPath}/history?id=${requestScope.historyCustomerId}&view=bookings&page=${i}">

                                            ${i}

                                        </a>


                                    </li>


                                </c:forEach>


                                <!-- Next -->

                                <li
                                    class="page-item
                                           ${currentPage == totalPages
                                             ? 'disabled'
                                             : ''}">


                                    <a
                                        class="page-link"
                                        href="${pageContext.request.contextPath}/history?id=${requestScope.historyCustomerId}&view=bookings&page=${currentPage + 1}">

                                        Next

                                    </a>


                                </li>


                            </ul>


                        </nav>


                    </c:if>


                </c:when>


                <c:otherwise>


                    <div class="alert alert-info text-center mt-5">


                        <c:choose>


                            <c:when test="${loggedUser.role == 'admin'
                                            || loggedUser.role == 'staff'}">

                                This customer has no bookings.

                            </c:when>


                            <c:otherwise>

                                You have no bookings yet.

                            </c:otherwise>


                        </c:choose>


                    </div>


                </c:otherwise>


            </c:choose>


        </div>


    </main>


    <%@include file="/WEB-INF/include/footer.jsp" %>


</div>


<script
    src="<%= request.getContextPath()%>/assets/js/bootstrap.bundle.min.js">
</script>


</body>

</html>