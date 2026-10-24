<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="My Orders" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<h3 class="mb-4"><i class="bi bi-box-seam"></i> My Orders</h3>

<c:if test="${empty orders}">
  <div class="text-center text-muted py-5">
    <i class="bi bi-inbox display-4"></i>
    <p class="mt-3">You haven't placed any orders yet.</p>
    <a href="${pageContext.request.contextPath}/products" class="btn btn-warning">Start shopping</a>
  </div>
</c:if>

<c:forEach var="o" items="${orders}">
  <div class="card shadow-sm mb-3">
    <div class="card-header d-flex justify-content-between flex-wrap">
      <span><strong>Order #${o.id}</strong> &middot; <fmt:formatDate value="${o.createdAt}" pattern="dd MMM yyyy, hh:mm a"/></span>
      <span class="badge text-bg-success">${o.status}</span>
    </div>
    <div class="card-body">
      <table class="table table-sm mb-2">
        <c:forEach var="i" items="${o.items}">
          <tr>
            <td><c:out value="${i.productName}"/></td>
            <td class="text-muted">&times; ${i.quantity}</td>
            <td class="text-end"><fmt:formatNumber value="${i.subtotal}" type="currency" currencySymbol="₹" maxFractionDigits="0"/></td>
          </tr>
        </c:forEach>
      </table>
      <div class="d-flex justify-content-between flex-wrap">
        <small class="text-muted"><i class="bi bi-geo-alt"></i> <c:out value="${o.address}"/></small>
        <strong>Total: <fmt:formatNumber value="${o.total}" type="currency" currencySymbol="₹" maxFractionDigits="0"/></strong>
      </div>
    </div>
  </div>
</c:forEach>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>
