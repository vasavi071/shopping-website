(function () {
  'use strict';

  // Bootstrap client-side validation (+ password confirmation match)
  document.querySelectorAll('.needs-validation').forEach(function (form) {
    form.addEventListener('submit', function (e) {
      var pw = form.querySelector('#password');
      var confirm = form.querySelector('#confirm');
      if (pw && confirm) {
        confirm.setCustomValidity(pw.value !== confirm.value ? 'Passwords do not match' : '');
      }
      if (!form.checkValidity()) {
        e.preventDefault();
        e.stopPropagation();
      }
      form.classList.add('was-validated');
    });
  });

  // Auto-submit the cart form when quantity changes
  document.querySelectorAll('.qty-auto-submit').forEach(function (input) {
    input.addEventListener('change', function () { input.form.submit(); });
  });

  // Confirm dangerous actions
  document.querySelectorAll('form[data-confirm]').forEach(function (form) {
    form.addEventListener('submit', function (e) {
      if (!window.confirm(form.getAttribute('data-confirm'))) e.preventDefault();
    });
  });

  // Auto-dismiss flash alerts
  document.querySelectorAll('.auto-dismiss').forEach(function (el) {
    setTimeout(function () {
      if (window.bootstrap) bootstrap.Alert.getOrCreateInstance(el).close();
    }, 4000);
  });
})();
