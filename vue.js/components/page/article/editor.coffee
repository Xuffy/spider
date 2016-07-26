'use strict'

api = require('ser/api')
tool = require('ser/tools')

module.exports = Vue.extend
  template: __inline('./editor.html')
  data: ->
    title: ''
    categoryId: ''
    resourceId: ''
  methods:
    getCategory: ->
      ctx = this
      api.category.get().then (data) ->
        data = data.data
        ctx.$set('category', data)
        ctx.$set('categoryId', data[0]?.id)

    save: ->
      ctx = this
      content = ctx.editor.value()

      return tool.tip('标题或内容不能为空') if !ctx.title or !content

      api.article.post({OA: 'add'}, {
        title: ctx.title
        content: content
        articleCategoryId: ctx.categoryId
        fileResourceId: ctx.resourceId
      }).then (data) ->
        if data.isOk
          tool.tip('发布成功').then ->
            window.location.reload()

    uploadSuccess: (data) ->

      this.resourceId = data.data.id

  filters:
    cate: (value)->
      (value || []).map (item)->
        text: item.name
        value: item.id

  compiled: ->
    this.getCategory()

  ready: ->
    ctx = this
    ctx.editor = editor = new SimpleMDE
      element: document.getElementById('editor')
      tabSize: 2
      spellChecker: false

    editor.render()

    viewCodeFn = editor.toolbar[11].action

    editor.toolbar[11].action = (e) ->
      viewCodeFn.call(editor, e)
      $('.editor-preview code').each (i, block) ->
        hljs.highlightBlock(block)


