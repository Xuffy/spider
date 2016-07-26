'use strict'

api = require('ser/api')
config = require('components/config').config
tool = require('ser/tools')

module.exports = Vue.extend
  inherit: true
  template: __inline('./cdn.html')
  data: ->
    control:
      left: [
        {
          title: '添加'
          action: ->
            $('#cdnModal').modal
              backdrop: 'static'
              show: true
        }
      ]
  methods:

    getCDN: ->
      # 获取CDN

      ctx = this
      api.cdn.get().then (data) ->
        data = data.data
        ctx.$set('cdn', data)
        ctx.$nextTick ->
          ctx.render()

    delete: ($event, id, link)->
      # 删除

      $this = $($event.target)

      layer.open
        content: '确定要删除吗? '
        btn: ['确认', '取消']
        shadeClose: false
        yes: ->
          api.cdn.post({OA: 'del'},
            id: id
            link: link
          ).then (data) ->
            if data.isOk
              tool.tip('删除成功')
              if link
                $this.parents('.list-group-item').remove()
              else
                $this.parents('.cdn').remove()
            else
              tool.tip('删除失败')


    save: ->
      # 保存

      ctx = this

      return tool.tip('请确认所有选项正确填写!') if !ctx.cdnName or !ctx.cdnVersion or !ctx.cdnUrl

      api.cdn.post({OA: 'add'},
        name: ctx.cdnName
        version: ctx.cdnVersion
        link: ctx.cdnUrl
      ).then (data) ->
        if data.isOk
          tool.tip('添加成功').then ->
            window.location.reload()
        else
          tool.tip('添加失败')

    render: ->
      # 监听复制

      client = new ZeroClipboard($('.btn-copy'))

      client.on 'ready', ->
        client.on 'copy', (event) ->
          event.clipboardData.setData('text/plain', $(event.target).siblings('a').html())

        client.on 'aftercopy', ->
          tool.tip('复制成功!')

  filters:
    search: (value, key) ->
      return value.filter (item) ->
        item.name.match(key)

  compiled: ->
    this.getCDN()
