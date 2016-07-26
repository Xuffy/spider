'use strict'

# 提示弹框
exports.tip = (content) ->
  new Promise (resolve) ->
    layer.open
      content: content
      time: 1
      end: ->
        resolve()

# 颜色加深
exports.getDarkColor = (color, level) ->
  rgbc = HexToRgb(color)
  for i in [0...3]
    rgbc[i] = Math.floor(rgbc[i] * (1 - level))
  return RgbToHex(rgbc[0], rgbc[1], rgbc[2])

# 颜色减浅
exports.getLightColor = (color, level) ->
  rgbc = HexToRgb(color)
  for i in [0...3]
    rgbc[i] = Math.floor((255 - rgbc[i]) * level + rgbc[i])
  return RgbToHex(rgbc[0], rgbc[1], rgbc[2])

HexToRgb = (str) ->
  str = str.replace("#", "")
  hxs = str.match(/../g)
  hxs[i] = parseInt(hxs[i], 16) for i in [0...3]
  return hxs

RgbToHex = (a, b, c) ->
  hexs = [a.toString(16), b.toString(16), c.toString(16)]
  for i in [0...3]
    hexs[i] = "0" + hexs[i] if hexs[i].length == 1
  return "#" + hexs.join("")