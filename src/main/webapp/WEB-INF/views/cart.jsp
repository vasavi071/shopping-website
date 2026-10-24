<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Your Cart" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<h3 class="mb-4"><i class="bi bi-cart3"></i> Shopping Cart</h3>

<c:choose>
<c:when test="${empty sessionScope.cart}">
  <div class="text-center py-5">
    <i class="bi bi-cart-x display-3 text-muted"></i>
    <p class="mt-3 text-muted">Your cart is empty.</p>
    <a href="${pageContext.request.contextPath}/products" class="btn btn-warning">Continue shopping</a>
  </div>
</c:when>
<c:otherwise>
<div class="row g-4">
  <div class="col-lg-8">
    <div class="table-responsive">
      <table class="table align-middle">
        <thead class="table-light">
          <tr><th>Product</th><th>Price</th><th style="width:130px">Qty</th><th>Subtotal</th><th></th></tr>
        </thead>
        <tbody>
        <c:forEach var="entry" items="${sessionScope.cart}">
          <c:set var="item" value="${entry.value}"/>
          <tr>
            <td>
              <div class="d-flex align-items-center gap-3">
                <img src="<c:out value='${item.imageUrl}'/>" class="cart-thumb rounded" alt="">
                <a class="text-decoration-none text-dark fw-semibold" href="${pageContext.request.contextPath}/product?id=${item.productId}">
                  <c:out value="${item.name}"/></a>
              </div>
            </td>
            <td><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₹" maxFractionDigits="0"/></td>
            <td>
              <form method="post" action="${pageContext.request.contextPath}/cart">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${item.productId}">
                <input type="number" name="quantity" value="${item.quantity}" min="0" max="${item.stock}"
                       class="form-control form-control-sm qty-auto-submit">
              </form>
            </td>
            <td class="fw-semibold"><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₹" maxFractionDigits="0"/></td>
            <td>
              <form method="post" action="${pageContext.request.contextPath}/cart">
                <input type="hidden" name="action" value="remove">
                <input type="hidden" name="id" value="${item.productId}">
                <button class="btn btn-sm btn-outline-danger" type="submit" title="Remove"><i class="bi bi-trash"></i></button>
              </form>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
    <form method="post" action="${pageContext.request.contextPath}/cart" data-confirm="Remove all items from your cart?">
      <input type="hidden" name="action" value="clear">
      <button class="btn btn-link text-danger p-0" type="submit">Clear cart</button>
    </form>
  </div>

  <div class="col-lg-4">
    <div class="card shadow-sm">
      <div class="card-body">
        <h5 class="card-title">Order summary</h5>
        <div class="d-flex justify-content-between"><span>Items</span><span>${sessionScope.cartCount}</span></div>
        <div class="d-flex justify-content-between"><span>Delivery</span><span class="text-success">FREE</span></div>
        <hr>
        <div class="d-flex justify-content-between fs-5 fw-bold">
          <span>Total</span>
          <span><fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="₹" maxFractionDigits="0"/></span>
        </div>
        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-warning w-100 mt-3">Proceed to checkout</a>
        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-dark w-100 mt-2">Continue shopping</a>
      </div>
    </div>
  </div>
</div>
</c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>
