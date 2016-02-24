var flash_callback, show_ajax_message;

//determine which class of flash message to utilise
show_ajax_message = function(message, type) {
  if (message && (type === "error" || type === "success" || type === "notice" || type === "warning")) {
    $("#flash-message").html("<div class='flash alert col-sm-6 col-sm-offset-3 fade in'>" + message + "</div>");
    if (type === "notice") {
      return $("#flash").addClass("notice-alert");
    } else if (type === "success") {
      return $("#flash").addClass("success-alert");
    } else if (type === "alert") {
      return $("#flash").addClass("danger-alert");
    } else if (type === "error") {
      return $("#flash").addClass("danger-alert");
    } else if (type === "flash") {
      return $("#flash").addClass("notice-alert");
    } else if (type === "warning") {
      return $("#flash").addClass("warning-alert");
    }
  }
};

//show flashes and make them timeout
$(document).ajaxComplete(function(event, request) {
  var message, type;
  message = request.getResponseHeader("X-Message");
  type = request.getResponseHeader("X-Message-Type");
  show_ajax_message(message, type);
  return setTimeout(flash_callback, 4500);
});

flash_callback = function() {
  return $(".flash").fadeOut(1200);
};
