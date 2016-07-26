'use strict'

api = require('ser/api')
config = require('components/config').config
tool = require('ser/tools')

module.exports = Vue.extend
  template: __inline('./list.html')
  data: ->
    cateId: 0
    pageIndex: 1
    keywords: ''
    article: []
    isMore: true
    control:
      right: [
        {
          title: '搜索'
          action: this.search
        }
      ]
  methods:
    getArticle: ->
      # 获取文章

      ctx = this
      api.article.get(
        categoryId: ctx.categoryId,
        keywords: ctx.keywords,
        pageSize: config.pageSize,
        pageIndex: ctx.pageIndex
      ).then (data) ->
        data = data.data

        ctx.isMore = false if _.isEmpty(data) || data.length < config.pageSize
        ctx.article = ctx.article.concat(data)

    getCategory: ->
      # 获取分类
      ctx = this
      api.category.get().then (data) ->
        ctx.$set('category', data.data)

    search: (id) ->
      # 搜索
      this.cateId = id if id and _.isNumber(id)
      this.article = []
      this.pageIndex = 1
      this.getArticle()

    loadMore: ->

      ctx = this
      ctx.pageIndex += 1
      ctx.getArticle()

  watch:
    'cateId': (id) ->
      this.search(id)
  computed:
    categoryId: ->
      if this.cateId == 0 then '' else this.cateId

  compiled: ->
    ctx = this

    # 初始化获取分类 和 文章

    ctx.getCategory()
    ctx.getArticle()
