// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery_ujs
//= require underscore
//= require d3.v3
//= require google_analytics
//= require hamlcoffee
//= require ./pi_base
//= require_tree .

// FIXME: restructure this
$(function() {
  var preview = function(input) {
    var text = input.find('.form-control').val();
    var pv = input.find('.preview');
    $(pv).text(text);
    pi_base.render_latex();
  }

  $('.markdown-input .form-control').keyup(function(e) {
    var input = $(this).closest('.markdown-input');
    pi_base.delay(300, preview, input);
  }).keyup();
});
