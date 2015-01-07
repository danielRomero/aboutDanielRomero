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

window.danielromero = {
  css_classes: ['default', 'primary', 'success', 'info', 'warning', 'danger']
}
window.danielromero.scroll_to = (elem) ->
  $("html, body").animate
    scrollTop: elem.offset().top - 60 #header height
  , 800

window.danielromero.ready = ->
  # google analytics initialize
  if typeof(ga) == "function"
    ga('create', 'UA-58306488-1', 'auto')
    ga('require', 'linkid', 'linkid.js')
    ga('send', 'pageview');

  # appear for avatar
  $('#about #me img.img-circle.img-responsive.avatar.pull-right.avatar_image').fadeIn 2000

  # soft appear for timeline boxes
  window.danielromero.soft_appear()

  # click event for skill pills
  $('#about #me span.label.skill').on "click", (event) ->
    window.danielromero.skill_click($(this))
    if typeof(ga) == "function"
      ga('send', 'event', 'button', 'click', "skill #{$(this).html()}")
    return

  # click event for hide progress bar
  $('#about #me .progress').on "click", (event) ->
    $(this).fadeOut()
    if typeof(ga) == "function"
      ga('send', 'event', 'button', 'click', 'progress bar')
    return

  # click event to track twitter pager buttons
  $( document ).on 'click', '#about #twitter ul.pager.tweet_pager li a', ->
    if typeof(ga) == "function"
      ga('send', 'event', 'button', 'click', "to page #{$(this).parent('li').attr('data-page')}")
    return

  # on scroll year bubbles are placed on header
  $(window).scroll ->
    offset = $(window).scrollTop()
    $('#about #me #timeline ul li .timeline-badge:not(.year)').each (index, element) ->
      
      header_elem = $('header#application_header .timeline-badge')

      if(parseInt(offset) < parseInt($('#about #me #timeline ul li .timeline-badge:not(.year)').first().offset().top) or parseInt(offset) > $('#twitter').offset().top)
        header_elem.fadeOut()
      else if (parseInt(offset) > parseInt($(element).offset().top))
        header_elem.fadeIn()
        header_elem.html($(element).html())
        header_elem.removeClass()
        
        css_class = ''
        for elem_class in $(element).attr('class').split(' ')
          if window.danielromero.css_classes.indexOf(elem_class) > 0
            css_class = elem_class

        header_elem.addClass("timeline-badge #{css_class}")
      return

  # track click to github
  $('footer#application_footer nav.navbar.navbar-default ul.nav.navbar-nav.github_project_link li a').on "click", (event) ->
    if typeof(ga) == "function"
      ga('send', 'event', 'button', 'click', 'fork this project')
    return
  'ul.nav.navbar-nav.navbar-center'

window.danielromero.soft_appear = () ->
  $('.daniel_romero .soft_appear').first().appear()
  $('.daniel_romero .soft_appear').on "appear", (event, elem) ->
    $(elem).find('.appear_elem').each (index, element) ->
      $(element).fadeIn 400, ->
        $('.daniel_romero .soft_appear').first().removeClass('soft_appear')
        window.danielromero.soft_appear()
        return
    $(this).unbind "appear"
    return
  $.force_appear()

window.danielromero.skill_click = (elem) ->
  $('#about #me .progress').fadeIn('slow')
  
  css_class = ''
  for elem_class in elem.attr('class').split(/-| /)
    if window.danielromero.css_classes.indexOf(elem_class) > 0
      css_class = elem_class
  
  progress_bar = $('#about #me .progress .progress-bar')

  progress_bar.html("#{elem.attr('data-percent')}% #{elem.html()}")
  
  progress_bar.width("#{elem.attr('data-percent')}%")
  progress_bar.attr('aria-valuenow', "#{elem.attr('data-percent')}")
  
  progress_bar.removeClass()
  
  progress_bar.addClass("progress-bar progress-bar-#{css_class} progress-bar-striped active")

# if turbolinks are not enabled
$(document).ready(window.danielromero.ready)
# if turbolinks are enabled
$(document).on('page:load', window.danielromero.ready)