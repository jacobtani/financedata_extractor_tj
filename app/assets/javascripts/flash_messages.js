var flashCallback, show_ajax_message;

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

$(document).ajaxComplete(function(event, request) {
  var message, type;
  message = request.getResponseHeader("X-Message");
  type = request.getResponseHeader("X-Message-Type");
  show_ajax_message(message, type);
  return setTimeout(flashCallback, 4500);
});

flashCallback = function() {
  return $(".flash").fadeOut(1200);
};
