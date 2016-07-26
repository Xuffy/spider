'use strict'

# modules

api = require('ser/api')
store = require('ser/store')
config = require('components/config').config
router = new VueRouter()
tool = require('ser/tools')

module.exports = Vue.extend
  template: __inline('./login.html')
  data: ->
    name: ''
    pass: ''
    nick: ''
  methods:
    chooseHead: (img)->
      this.$set('headImgId', img.id)

    login: -> # 登录
      ctx = this
      return layer.open({content: '用户名或密码不能未空', time: 1}) if !ctx.name or !ctx.pass

      api.user.post({'OA': 'login'},
        name: ctx.name
        password: ctx.pass
      ).then (data) ->
        if data.desc == '该用户不存在,请继续完成注册!'
          layer.open
            content: '该账号没有注册, 需要注册该账号吗'
            btn: ['确认', '取消']
            shadeClose: false
            yes: (index) ->
              layer.close(index)
              showStep(2)
        else if data.isOk
          store.set 'UF',
            token: data.data.token,
            expired: (_.now() + config.expired * 1000 * 60)
          router.go('/article')
        else
          tool.tip('用户名或密码错误')

    register: -> # 注册
      ctx = this

      return tool.tip('昵称不能为空') if !ctx.nick

      api.user.post({'OA': 'login'}, {
        name: ctx.name,
        password: ctx.pass,
        nickName: ctx.nick,
        headImgId: ctx.headImgId
      }).then (data) ->
        store.set 'UF',
          token: data.data.token,
          expired: (_.now() + config.expired * 1000 * 60)
        tool.tip('注册成功')
        router.go('/article')
  compiled: ->
    ctx = this
    # 获取头像列表
    api.headImg.get().then (data) ->
      data = data.data
      ctx.$set('headImgs', data)
      ctx.$set('headImgId', data[0]?.id)
  ready: ->
    # 返回
    $('.btn-return').on 'click', showStep.bind(null, 1)

# 展示相应界面

showStep = (index) ->
  divs = ['.step-one', '.step-two']
  i = 0

  divs = divs.map (item) ->
    return $(item)

  divs.forEach (item) ->
    item.animate {'opacity': 0}, ->
      i++
      $(this).addClass('hidden')
      if (i == divs.length)
        divs[index - 1].removeClass('hidden').animate({'opacity': 1})