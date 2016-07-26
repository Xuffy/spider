'use strict'

# header

store = require('ser/store')
tool = require('ser/tools')
config = require('components/config').config

Vue.component 'sp-upload',
  template: __inline('./index.html')

  props: ['success', 'api']

  ready: ->
    ctx = this

    ctx.api = config.host + '/api/resource/add'

    $modalEl = $('#fileModal')
    $descEl = $('input[type=text]')
    $fileEl = $('input[type=file]')

    $('#uploadFile').ajaxForm
      dataType: 'json'
      beforeSend: (xhr) ->
        if !$descEl.val() or !$fileEl.val()
          tool.tip('请确认信息填写完整!')
        xhr.setRequestHeader('Authorization', store.get('UF').token)
      success: (data) ->
        tool.tip('添加成功').then ->
          $modalEl.modal('hide')
          ctx.success(data)
      error: ->
        tool.tip('添加失败').then ->
          $modalEl.modal('hide')