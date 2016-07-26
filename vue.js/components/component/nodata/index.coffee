'use strict'

# 当数据为空时 展示无数据层

Vue.component 'sp-no-data',
  template: __inline('./index.html')
  data: ->
    isShow: false
  props: ['data']
  watch:
    data: (value) ->
      this.isShow = _.isEmpty(value)