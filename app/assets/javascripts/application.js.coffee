# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.

# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.

# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.

# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.

#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require_tree .
#= require bootstrap-sprockets
window.danielromero = {}
window.danielromero.scroll_to = (elem) ->
  $("html, body").animate
    scrollTop: elem.offset().top - 60 #header height
  , 800

window.danielromero.ready = ->
  window.danielromero.soft_appear()

window.danielromero.soft_appear = () ->
  $('.daniel_romero .soft_appear').first().appear()
  $('.daniel_romero .soft_appear').first().appear().on "appear", (event, elem) ->
    $(elem).find('.appear_elem').each (index, element) ->
      $(element).fadeIn 800, ->
        $('.daniel_romero .soft_appear').first().removeClass('soft_appear')
        window.danielromero.soft_appear()
        return
    $(this).unbind "appear"
    return
  $.force_appear()

# window.danielromero.soft_appear = () ->
#   $('.daniel_romero .soft_appear').appear()
#   $('.daniel_romero .soft_appear').on "appear", (event, elem) ->
#     $(elem).find('.appear_elem').each (index, element) ->
#       $(element).delay(500*index).fadeIn 1500, ->
#         return
#     $(this).unbind "appear"
#     return
#   $.force_appear()

$(document).ready(window.danielromero.ready)
$(document).on('page:load', window.danielromero.ready)