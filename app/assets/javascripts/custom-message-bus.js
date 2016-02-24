var checkNewStockData, initMessageBus,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

//initialise MessageBus
initMessageBus = function() {
  MessageBus.start();
  return MessageBus.callbackInterval = 1000;
};

//format the date in DD/YY/YYYY
formatDate = function (currentDate) {
  var twoDigitMonth=((currentDate.getMonth()+1)>=10)? (currentDate.getMonth()+1) : '0' + (currentDate.getMonth()+1);  
  var twoDigitDate=((currentDate.getDate())>=10)? (currentDate.getDate()) : '0' + (currentDate.getDate());
  var date_formatted = twoDigitDate + "/" + twoDigitMonth + "/" + currentDate.getFullYear(); 
  return date_formatted
};

//format the time in HH:MM:SS
formatTime = function (time) {
  var hours = ((time.getHours())>=10)? (time.getHours()) : '0' + (time.getHours());
  var minutes = ((time.getMinutes())>=10)? (time.getMinutes()) : '0' + (time.getMinutes());
  var seconds = ((time.getSeconds())>=10)? (time.getSeconds()) : '0' + (time.getSeconds());
  var time_formatted = hours + ":" + minutes + ":" + seconds
  return time_formatted
};

checkNewStockData = function() {
  MessageBus.subscribe("/new_quote_data", function(data) {
    
    //data retrieved from message bus
    var quoteData = data.quote_data;
    
    //go through each row of data to update the table
    for(var i=0;i<quoteData.length; i++) {

      var stock_record = quoteData[i];
      var symbol = stock_record.Symbol.substring(0,2);
      var price = (parseFloat(stock_record.LastTradePriceOnly)).toFixed(2)

      //Configure format of date 
      var currentDate = new Date(stock_record.LastTradeDate);
      var stock_formatted_date = formatDate(currentDate);

      //Update data in current table
      $('.' + symbol).children('td').eq(2).text('$' + price);
      $('.' + symbol).children('td').eq(3).text(stock_formatted_date + " " + (stock_record.LastTradeWithTime).split(' -')[0]);
      
      //Determine if data has changed state or not and add highlighting if necessary    
      if (stock_record.ChangedValue.toString() == 'true') {
        $('.' + symbol).addClass('highlight')
      }
      else {
       	$('.' + symbol).removeClass('highlight')
      }
    }

    //Update the last updated at header with a formatted date
    var page_date_unformatted = new Date()
    var page_date_formatted = formatDate(page_date_unformatted)
    var page_time_formatted = formatTime(page_date_unformatted)
    $('#hd-updated').text('Last Updated at ' + page_date_formatted + ' ' + page_time_formatted);

  })
};

$(document).ready(function() {
  initMessageBus();
  checkNewStockData();
});