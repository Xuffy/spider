'use strict'

# header

Vue.component 'sp-control-bar',
  inherit: true
  template: __inline('./index.html')
  props: [
    'placeholder'
    'control'
    'inputModel'
  ]