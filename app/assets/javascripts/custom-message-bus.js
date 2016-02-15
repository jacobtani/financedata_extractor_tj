// For the time now
Date.prototype.timeNow = function () {
     return ((this.getHours() < 10)?"0":"") + this.getHours() +":"+ ((this.getMinutes() < 10)?"0":"") + this.getMinutes() +":"+ ((this.getSeconds() < 10)?"0":"") + this.getSeconds();
}

var checkQuoteData, initMessageBus,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

initMessageBus = function() {
  MessageBus.start();
  return MessageBus.callbackInterval = 1000;
};

checkQuoteData = function() {
  MessageBus.subscribe("/new_quote_data", function(data) {
       var quoteData = data.quote_data;
       for(var i=0;i<quoteData.length; i++) {
       	var item = quoteData[i];
       	var name = item.Name;
       	$('#' + quoteData.Name).children('td').eq(1).text(item.LastTradePriceOnly);
       	$('#' + quoteData.Name).children('td').eq(2).text(item.LastTradeDate);
       	// if changed
       	// add class 'highlight'
       	// else
       	// do nothing
       }
       var date = new Date();
       $('#hd-updated').text('Last Updated at ' + date.timeNow());
    })
};

$(document).ready(function() {
  initMessageBus();
  checkQuoteData();
});