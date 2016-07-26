'use strict'

api = require('ser/api')
config = require('components/config').config
tool = require('ser/tools')
router = require('ser/router')

module.exports = Vue.extend
  template: __inline('./detail.html')
  data: ->
    article: {}
    isDoc: false
    host: config.host
  methods:
    getCate: ->
      # 获取分类
      ctx = this
      api.category.get().then (data) ->
        data = data.data
        ctx.$set('category', data)

    getArticle: ->
      # 获取文章
      ctx = this

      api.article.get(
        OA: ctx.$route.params.id
      ).then (data) ->
        data = data.data
        file = data.file_resource
        ctx.isDoc = true if file and file.type in config.docType
        ctx.$set('article', data)
        ctx.$set('categoryId', data.category.id)
        ctx.$nextTick ->
          ctx.render()

    render: ->
      ctx = this
      $('code').each (i, block) ->
        hljs.highlightBlock(block)
      ctx.editor = editor = new SimpleMDE
        element: document.getElementById('editor')
        tabSize: 2
        spellChecker: false
        initialValue: ctx.article.content
        toolbar: [
          'bold', 'italic', 'heading', '|', 'quote', 'unordered-list', 'ordered-list', '|', 'link', 'image', '|',
          'preview'
        ]

      editor.render()

      viewCodeFn = editor.toolbar[11].action

      editor.toolbar[11].action = (e) ->
        viewCodeFn.call(editor, e)
        $('.editor-preview code').each (i, block) ->
          hljs.highlightBlock(block)

    delete: ->
      ctx = this
      layer.open
        content: '确定要删除吗? '
        btn: ['确认', '取消']
        shadeClose: false
        yes: ->
          api.article.post({OA: 'del'},
            id: ctx.$route.params.id
          ).then (data) ->
            if data.isOk
              tool.tip('删除成功').then ->
                ctx.$route.router.go('/article')
            else
              tool.tip(data.desc)
    update: ->
      ctx = this
      api.article.post({OA: 'update'},
        id: ctx.$route.params.id
        title: ctx.article.title
        content: ctx.editor.value()
        articleCategoryId: ctx.categoryId
      ).then (data)->
        if data.isOk
          tool.tip('更新成功').then ->
            window.location.reload()
        else
          tool.tip(data.desc)

    down: (url) ->
      window.open(this.host + '/' + url)
  filters:
    markedown: (value) ->
      value && marked(value)
    cate: (value)->
      (value || []).map (item)->
        text: item.name
        value: item.id
  compiled: ->
    # 初始化获取分类 和 文章

    this.getArticle()
    this.getCate()