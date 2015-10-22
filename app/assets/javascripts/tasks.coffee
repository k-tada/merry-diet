# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = () ->
  $('.datetimepicker').datetimepicker {
    step: 15
    minTime: '7:00'
  }
  $('.datetimepicker').click () ->
    $(this).blur()
  $('#top .task li a').click () ->
    confirm "このタスクを完了にするわよ"
  $('img.comingsoon').click () ->
    alert 'まだ準備出来てないからもうちょっと待っててよね！'


$(document).ready ready
$(document).on 'page:load', ready

