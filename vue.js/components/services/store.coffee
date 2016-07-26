'use strict'

exports.set = (key, value) ->
  window.localStorage.setItem(key, JSON.stringify(value))

exports.get = (key) ->
  JSON.parse(window.localStorage.getItem(key) || '[]')