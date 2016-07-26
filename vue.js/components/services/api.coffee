'use strict'

# modules
store = require('./store')
config = require('../config').config
router = new VueRouter()

Vue.http.options.root = config.host + '/api'

# API 对象
# ser = require('ser/api')
# ser.user.post({OA: 'login'}).then(function(data){})

[
  'article'
  'headImg'
  'user'
  'category'
  'cdn'
  'resource'
  'mock'
].forEach (item) ->
  resource = Vue.resource(item + '/:OA/:TA')
  exports[item] =
    get: (params) ->
      Vue.http.headers.common['Authorization'] = store.get('UF').token
      new Promise (resolve, reject) ->
        resource.get(params, resolve).error (data, status)->
          if status == 403
            store.set('UF', '')
            return router.go('/login')
          reject(data)
    post: (params, data) ->
      Vue.http.headers.common['Authorization'] = store.get('UF').token
      new Promise (resolve, reject) ->
        resource.save(params, data, resolve).error (data, status) ->
          if status == 403
            store.set('UF', '')
            return router.go('/login')
          reject(data)