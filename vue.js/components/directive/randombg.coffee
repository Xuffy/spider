'use strict'

tool = require('ser/tools')

Vue.directive 'random-bg',
  bind: ->
    $el = $(this.el)
    color = randomColor({luminosity: 'light'})
    $el
    .css
      backgroundColor: color
    .find('button')
    .hover ->
      $(this).css
        backgroundColor: tool.getDarkColor(color, .1)
    , ->
      $(this).css
        backgroundColor: color