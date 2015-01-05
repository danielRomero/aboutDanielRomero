# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.twitter_index = {}

window.twitter_index.change_page = (page) ->
  $('#twitter .tweet_index').hide()
  $('#twitter ul.pager.tweet_pager').hide()
  if page != undefined
    $("#twitter_pager_#{page}").show()
    $("#tweets_index_#{page}").show()