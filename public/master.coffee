
$ ->

  # $('body').height($(document).height() * 0.98)

  $("#chat_form input[type=submit]").hide()

  hide_flash = ->
    $('.flash').css 'visibility', 'hidden'
    $('.flash').css 'opacity', 0
    $('.flash').css 'color', 'rgba(0,0,0,0)'

  $('body').click ->
    firstHeight = $(".flash").height()
    firstWidth = $('.flash').css 'border-width'
    firstColor = $('.flash').css 'border-color'
    $(".flash").animate {
      height: 0,
      padding: 0,
      margin: 0
    }, {
      duration: 500,
      complete: hide_flash
      step: (currentHeight) ->
        percentage = currentHeight/(firstHeight*2.0) * firstWidth
        $('.flash').css 'border', "#{percentage}px solid #{firstColor}"
    }

  $('.theme').click ->
    theme = $(this).data 'theme'
    $.post '/set_theme', {
      _csrf: AUTH_TOKEN,
      theme: theme
    }, ->
      location.reload()

  $('#user_search').keyup (e) ->
    value = $(this).val()
    if e.keyCode == 13
      if $("#user_index p:visible").length == 1
        location.pathname = $("#user_index p:visible a").attr 'href'
      else
        $('#user_index p a').each ->
          if ///^#{value}$///i.test $(this).text()
            location.pathname = $(this).attr 'href'
    height = $("#user_index").height()
    $('#user_index p').each ->
      unless ///#{value}///i.test $(this).text()
        $(this).hide()
      else
        $(this).show()
      $("#user_index").height(height)
