<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><c:out value="${empty pageTitle ? 'ShopEasy' : pageTitle}"/> | ShopEasy</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body class="d-flex flex-column min-vh-100">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
  <div class="container">
    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/products">
      <i class="bi bi-bag-heart-fill text-warning"></i> ShopEasy
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#nav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="nav">
      <form class="d-flex mx-lg-4 my-2 my-lg-0 flex-grow-1" action="${pageContext.request.contextPath}/products" method="get">
        <input class="form-control me-2" type="search" name="q" placeholder="Search products..."
               value="<c:out value='${q}'/>" aria-label="Search">
        <button class="btn btn-warning" type="submit"><i class="bi bi-search"></i></button>
      </form>
      <ul class="navbar-nav ms-auto align-items-lg-center">
        <li class="nav-item">
          <a class="nav-link position-relative" href="${pageContext.request.contextPath}/cart">
            <i class="bi bi-cart3 fs-5"></i> Cart
            <c:if test="${sessionScope.cartCount > 0}">
              <span class="badge rounded-pill bg-warning text-dark">${sessionScope.cartCount}</span>
            </c:if>
          </a>
        </li>
        <c:choose>
          <c:when test="${not empty sessionScope.user}">
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
                <i class="bi bi-person-circle"></i> <c:out value="${sessionScope.user.name}"/>
              </a>
              <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orders">My Orders</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
              </ul>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a></li>
            <li class="nav-item"><a class="btn btn-outline-warning btn-sm ms-lg-2" href="${pageContext.request.contextPath}/register">Sign up</a></li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>

<main class="container py-4 flex-grow-1">
  <c:if test="${not empty sessionScope.flash}">
    <div class="alert alert-${sessionScope.flashType} alert-dismissible fade show auto-dismiss" role="alert">
      <c:out value="${sessionScope.flash}"/>
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <c:remove var="flash" scope="session"/>
    <c:remove var="flashType" scope="session"/>
  </c:if>
