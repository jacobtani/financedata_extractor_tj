// For the time now
Date.prototype.timeNow = function () {
     return ((this.getHours() < 10)?"0":"") + this.getHours() +":"+ ((this.getMinutes() < 10)?"0":"") + this.getMinutes() +":"+ ((this.getSeconds() < 10)?"0":"") + this.getSeconds();
}

var checkCurrentData, initMessageBus,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

initMessageBus = function() {
  MessageBus.start();
  return MessageBus.callbackInterval = 1000;
};

checkCurrentData = function() {
  MessageBus.subscribe("/new_quote_data", function(data) {
    
    //data retrieved from message bus
    var quoteData = data.quote_data;
    var changedData = data.changed_data
    

    for(var i=0;i<quoteData.length; i++) {
      var item = quoteData[i];
      var name_substring = item.Name.substring(0,5);
      var price = (parseFloat(item.LastTradePriceOnly)).toFixed(2)
      
      //Configure format of date 
      var currentDate = new Date(item.LastTradeDate);
      var twoDigitMonth=((currentDate.getMonth()+1)>=10)? (currentDate.getMonth()+1) : '0' + (currentDate.getMonth()+1);  
      var twoDigitDate=((currentDate.getDate())>=10)? (currentDate.getDate()) : '0' + (currentDate.getDate());
      var date = twoDigitDate + "/" + twoDigitMonth + "/" + currentDate.getFullYear(); 
      
      //Update data in current table
      $('.' + name_substring).children('td').eq(1).text('$' + price);
      $('.' + name_substring).children('td').eq(2).text(date + " " + (item.LastTradeWithTime).split(' -')[0]);
      
      //Determine if data has changed state or not and add highlighting if necessary    
      if (changedData[item.Name].toString() == 'true') {
        $('.' + name_substring).addClass('highlight')
      }
      else {
       	$('.' + name_substring).removeClass('highlight')
      }
    }

    //Update the last updated at header
    var date = new Date();
    $('#hd-updated').text('Last Updated at ' + date.timeNow());
  })
};

$(document).ready(function() {
  initMessageBus();
  checkCurrentData();
});