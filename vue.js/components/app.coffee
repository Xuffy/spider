'use strict'

# component

header = require('component/header/index')
upload = require('component/upload/index')
nodata = require('component/nodata/index')
controlbar = require('component/controlbar/index')

# module

require('directive/randombg')
require('filter/format')
store = require('ser/store')
config = require('./config').config
router = require('ser/router').router

# 解决300ms click延迟

FastClick.attach(document.body)

# 判断是否登录 or 用户是否过期

User = store.get('UF')
isLogin = !_.isEmpty(User)

if !isLogin or (isLogin && User.expired < _.now())
  router.go('/login')

