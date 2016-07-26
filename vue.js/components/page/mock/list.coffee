'use strict'

api = require('ser/api')
config = require('components/config').config
tool = require('ser/tools')

module.exports = Vue.extend
  template: __inline('./list.html')

  data: ->

    pageIndex: 1
    keywords: ''
    mock: []
    isMore: true
    control:
      left: [
        {
          title: '添加'
          action: ->
            $('#mockModal').modal
              backdrop: 'static'
              show: true
        }
      ]
      right: [
        {
          title: '搜索'
          action: this.search
        }
      ]

  methods:

    getMock: ->
      # 获取Mock

      ctx = this
      api.mock.get(
        keywords: ctx.keywords,
        pageSize: config.pageSize,
        pageIndex: ctx.pageIndex
      ).then (data) ->
        data = data.data

        ctx.isMore = false if _.isEmpty(data) || data.length < config.pageSize
        ctx.mock = ctx.mock.concat(data)

    delete: ($event, id) ->
      # 删除

      layer.open
        content: '确定要删除吗? '
        btn: ['确认', '取消']
        shadeClose: false
        yes: ->
          api.mock.post({OA: 'del'},
            id:id
          ).then (data) ->

            if data.isOk
              tool.tip('删除成功').then ->
                $($event.target).parents('.item-square').remove()
            else
              tool.tip('删除失败')

    save: ->
      # 保存

      ctx = this

      return tool.tip('请填写完整信息!') if !ctx.mockUrl or !ctx.mockDesc

      api.mock.post({OA: 'add'},
        url: ctx.mockUrl
        describe: ctx.mockDesc
      ).then (data) ->
        if data.isOk
          tool.tip('添加成功').then ->
            window.location.reload()
        else
          tool.tip('添加失败')

    search: ->
      # 搜索

      this.mock = []
      this.pageIndex = 1
      this.getMock()

    loadMore: ->
      # 加载更多

      this.pageIndex += 1
      this.getMock()

  compiled: ->

    this.getMock()
