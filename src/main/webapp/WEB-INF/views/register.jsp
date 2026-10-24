<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Sign up" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<div class="row justify-content-center">
  <div class="col-md-6 col-lg-5">
    <div class="card shadow-sm">
      <div class="card-body p-4">
        <h4 class="mb-3 text-center">Create account</h4>
        <c:if test="${not empty error}"><div class="alert alert-danger"><c:out value="${error}"/></div></c:if>
        <form method="post" action="${pageContext.request.contextPath}/register" class="needs-validation" novalidate>
          <div class="mb-3">
            <label class="form-label" for="name">Full name</label>
            <input class="form-control" id="name" name="name" value="<c:out value='${name}'/>" minlength="2" required>
            <div class="invalid-feedback">Please enter your name.</div>
          </div>
          <div class="mb-3">
            <label class="form-label" for="email">Email</label>
            <input type="email" class="form-control" id="email" name="email" value="<c:out value='${email}'/>" required>
            <div class="invalid-feedback">Enter a valid email.</div>
          </div>
          <div class="mb-3">
            <label class="form-label" for="password">Password</label>
            <input type="password" class="form-control" id="password" name="password" minlength="6" required>
            <div class="invalid-feedback">At least 6 characters.</div>
          </div>
          <div class="mb-3">
            <label class="form-label" for="confirm">Confirm password</label>
            <input type="password" class="form-control" id="confirm" name="confirm" required>
            <div class="invalid-feedback">Passwords must match.</div>
          </div>
          <button class="btn btn-warning w-100" type="submit">Sign up</button>
        </form>
        <p class="text-center mt-3 mb-0">Already registered? <a href="${pageContext.request.contextPath}/login">Login</a></p>
      </div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>
