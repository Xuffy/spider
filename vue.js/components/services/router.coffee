'use strict'

# router

Share = require('biz/article/editor')
Login = require('biz/user/login')
Article = require('biz/article/list')
ArticleDetail = require('biz/article/detail')
CDN = require('biz/cdn/cdn')
Resource = require('biz/resource/resource')
Mock = require('biz/mock/list')
MockDetail = require('biz/mock/detail')

# module

store = require('./store')

exports.app = App = Vue.extend({})
exports.router = router = new VueRouter()

router.map
  '/login':
    'component': Login
  '/share':
    'component': Share
  '/article':
    'component': Article
  '/article/:id':
    'component': ArticleDetail
  '/resource':
    'component': Resource
  '/mock':
    'component': Mock
  '/mock/:id':
    'component': MockDetail
  '/cdn':
    'component': CDN

router.start(App, '#app')

# 当检测到根路由时 跳转到详情

router.afterEach (transition) ->
  if transition.to.path == '/'
    router.go('/article')