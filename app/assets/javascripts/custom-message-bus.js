var checkMapStatus, initMessageBus,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

initMessageBus = function() {
  MessageBus.start();
  return MessageBus.callbackInterval = 1000;
};

checkMapStatus = function() {
  MessageBus.subscribe("/new_quote_data", function(quote_data) {
      debugger
      alert ('GOT DATA')

    })
};

$(document).ready(function() {
  initMessageBus();
 checkMapStatus();
});