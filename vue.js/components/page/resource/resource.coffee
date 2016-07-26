'use strict'

api = require('ser/api')
store = require('ser/store')
config = require('components/config').config
tool = require('ser/tools')
router = require('ser/router')

module.exports = Vue.extend
  template: __inline('./resource.html')
  data: ->
    pageIndex: 1
    keywords: ''
    resource: []
    isMore: true
    host: config.host
    currentUpdateItem:
      fileName: ''
      file: ''
    allowEditorType: config.allowEditorType
    control:
      left: [
        {
          title: '添加'
          action: ->
            $('#fileModal').modal
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
    getResource: ->
      # 获取

      ctx = this
      api.resource.get(
        keywords: ctx.keywords,
        pageSize: config.pageSize,
        pageIndex: ctx.pageIndex
      ).then (data) ->
        data = data.data

        ctx.isMore = false if _.isEmpty(data) || data.length < config.pageSize
        ctx.resource = ctx.resource.concat(data)

    search: ->
      # 搜索

      this.resource = []
      this.pageIndex = 1
      this.getResource()

    loadMore: ->
      # 加载更多

      ctx = this
      ctx.pageIndex += 1
      ctx.getResource()

    openEditor: (file) ->
      # 打开编辑器

      ctx = this

      $
      .get(this.host + '/' + file)
      .success (data) ->
        # 将要编辑的对象赋予currentUpdateItem
        ctx.currentUpdateItem.fileName = file
        ctx.currentUpdateItem.file = data
        $('#resourceModal').modal
          backdrop: 'static'
          show: true

    updateFile: ->
      # 更新资源文件

      ctx = this

      api.resource.post({OA: 'updateFile'},
        fileName: ctx.currentUpdateItem.fileName
        file: ctx.currentUpdateItem.file
      ).then (data) ->
        if data.isOk
          tool.tip('更新成功').then ->
            window.location.reload()
        else
          tool.tip('更新失败')

    isEditor: (item) ->
      # 是否允许编辑

      ctx = this
      type = item.file.split('.');

      if(type.length < 2 || _.indexOf(ctx.allowEditorType, type[type.length - 1].toUpperCase()) == -1)
      then return false
      else return true

    delete: ($event, id)->
      # 删除

      layer.open
        content: '确定要删除吗? '
        btn: ['确认', '取消']
        shadeClose: false
        yes: ->
          api.resource.post({OA: 'del'},
            id: id
          ).then (data) ->
            if data.isOk
              tool.tip('删除成功').then ->
                $($event.target).parents('.item-square').remove()
            else
              tool.tip('删除失败')
    uploadSuccess: ->

      window.location.reload()

    down: (url) ->
      window.open(this.host + '/' + url)

  compiled: ->
    # 初始化获取共享资源
    this.getResource()