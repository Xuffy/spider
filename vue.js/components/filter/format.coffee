'use strict'

Vue.filter 'format', (date) ->
  date = (new Date(date)).getTime()
  now = +new Date
  text = ''
  distance = now - date
  if distance <= 86400 * 1000
    text = Math.round((now - date) / 3600000) + "小时以前"
  else if distance < 86400000 * 30
    text = Math.round((now - date) / 86400000) + "天以前"
  else if distance < 86400000 * 30 * 12
    text = Math.round((now - date) / 86400000 / 30) + "个月以前"
  else
    text = "一年以前"
