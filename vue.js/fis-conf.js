fis.hook('module', {
  mode : 'mod',
  paths: {
    jQuery    : 'lib/jquery/dist/jquery.min.js',
    bootstrap : 'lib/bootstrap/js/bootstrap.min.js',
    fastclick : 'lib/fastclick/lib/fastclick.js',
    layer     : 'lib/layer.m/layer.m.js',
    highlight : 'lib/highlight/highlight.pack.js',
    simplemde : 'lib/simplemde/dist/simplemde.min.js',
    vue       : 'lib/vue/dist/vue.min.js',
    vueRouter : 'lib/vue-router/dist/vue-router.min.js',
    underscore: 'lib/underscore/underscore-min.js',
    biz       : 'components/page',
    ser       : 'components/services',
    filter    : 'components/filter'
  }
});

//components下面的所有js资源都是组件化资源
fis.match("components/**", {
  isMod: true
});

fis.match('*.styl', {
  // 编译之后后缀
  rExt  : '.css',
  // 开启编译
  parser: fis.plugin('stylus')
});

fis.match('*.coffee', {
  // 编译之后后缀
  rExt  : '.js',
  // 开启编译
  parser: fis.plugin('coffee-script')
});

fis.match('::packager', {
  // npm install [-g] fis3-postpackager-loader
  // 分析 __RESOURCE_MAP__ 结构，来解决资源加载问题
  postpackager: fis.plugin('loader', {
    resourceType: 'mod',
    useInlineMap: true // 资源映射表内嵌
  }),
  packager    : fis.plugin('map'),
  spriter     : fis.plugin('csssprites', {
    layout: 'matrix',
    margin: '15'
  })
});