'use strict'

# 开发环境

dev = 'http://10.10.7.107:7000'

# 生产环境

pro = 'http://172.16.0.201:7000'

exports.config =
  expired: 60 # token 过期时间
  host: pro
  pageSize: 40
  allowEditorType: ['JS', 'CSS', 'HTML', 'JSON', 'TXT']
  docType: ['DOC', 'DOCX', 'PPT', 'PPTX', 'ODT']