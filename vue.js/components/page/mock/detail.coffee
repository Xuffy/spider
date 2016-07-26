'use strict'

api = require('ser/api')
config = require('components/config').config
tool = require('ser/tools')
router = require('ser/router')

module.exports = Vue.extend
  template: __inline('./detail.html')
  data: ->
    isSave: false
    host: config.host
    mockListUrl: ''
    mockListDesc: ''
    mockListMode: ''
    mockId: ''
    control:
      left: [
        {
          title: '添加'
          action: this.add
        }
      ]

  methods:
    getMock: ->
      # 获取
      ctx = this
      api.mock.get(
        OA: ctx.$route.params.id
      ).then (data) ->
        data = data.data
        ctx.$set('mock', data)

    delete: ($event, id) ->
      layer.open
        content: '确定要删除吗? '
        btn: ['确认', '取消']
        shadeClose: false
        yes: ->
          api.mock.post({OA: 'list', TA: 'del'},
            id: id
          ).then (data) ->
            if data.isOk
              tool.tip('删除成功').then ->
                $($event.target).parents('tr').remove()
            else
              tool.tip('删除失败')

    add: ->
      # 添加
      ctx = this
      ctx.isSave = true # 标记当前状态为保存
      ctx.mockListMethod = 'GET'
      ctx.mockListUrl = ''
      ctx.mockListDesc = ''
      ctx.mockListMode = ''
      $('#mockListModal').modal
        backdrop: 'static'
        show: true

    update: (item) ->
      # 更新
      ctx = this
      ctx.isSave = false # 标记当前状态为更新
      ctx.mockId = item.id
      ctx.mockListUrl = item.url
      ctx.mockListDesc = item.describe
      ctx.mockListMode = item.mode
      ctx.mockListMethod = item.method
      $('#mockListModal').modal
        backdrop: 'static'
        show: true

    save: ->
      # 保存
      ctx = this

      return tool.tip('请填写完整信息!') if !ctx.mockListUrl or !ctx.mockListDesc or !ctx.mockListMode

      try
        JSON.parse(ctx.mockListMode)
      catch
        if !/http:\/\//.test(ctx.mockListMode)
          return tool.tip('数据模型转换失败, 确定是否是JSON对象')

      if ctx.isSave
        api.mock.post({OA: 'list', TA: 'add'},
          mockId: ctx.$route.params.id
          url: ctx.mockListUrl
          describe: ctx.mockListDesc
          method: ctx.mockListMethod
          mode: ctx.mockListMode
        ).then (data) ->
          if data.isOk
            tool.tip('添加成功').then ->
              window.location.reload()
          else
            tool.tip('添加失败')
      else
        api.mock.post({OA: 'list', TA: 'update'},
          id: ctx.mockId
          url: ctx.mockListUrl
          describe: ctx.mockListDesc
          method: ctx.mockListMethod
          mode: ctx.mockListMode
        ).then (data) ->
          if data.isOk
            tool.tip('更新成功').then ->
              window.location.reload()
          else
            tool.tip(data.desc)

    view: (mock) ->
      window.open(this.host + '/m' + mock.mock.url + mock.url)
    help: ->
      window.open('http://mockjs.com')

  filters:
    search: (value, key) ->
      return value.filter (item) ->
        item.describe.match(key) || ('/m' + item.mock.url + item.url).match(key)

  compiled: ->
    this.getMock()
