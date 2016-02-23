// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require select2
//= require stocks
//= require flash_messages
//= require message-bus
//= require custom-message-bus
//= require_tree .

//helper method to work with stocks.js methods
function split(str, separator, limit) {
    str = str.split(separator);
    if(str.length <= limit) return str;

    var ret = str.splice(0, limit);
    ret.push(str.join(separator));

    return ret;
}
