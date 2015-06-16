$(document).on('submit', 'form[data-turbolinks-form]', function(e) {
  var options = {};
  Turbolinks.visit(
    this.action + (this.action.indexOf('?') === -1 ? '?' : '&') + $(this).serialize(),
    options
  );
  return false;
});
