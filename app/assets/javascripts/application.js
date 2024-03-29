// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .

$(document).on('change', 'input#boss', function(){
  $('input:checkbox').prop('checked', this.checked)
})

$(document).on('change', '.single input[type=checkbox]', function(){
  generalCheckState()
})

function generalCheckState() {
  var checkedCount = document.querySelectorAll('.single input:checked').length;
    checkboxes = document.querySelectorAll('.single input[type=checkbox]');
    checkall = document.getElementById('boss');
    if (checkall) {
        checkall.checked = checkedCount == checkboxes.length;
        checkall.indeterminate = checkedCount > 0 && checkedCount < checkboxes.length;
    }
}

$(document).ready(function(){
   generalCheckState();
 });
