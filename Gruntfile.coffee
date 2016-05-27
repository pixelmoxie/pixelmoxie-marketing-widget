module.exports = ( grunt, config ) ->
  path = require( 'path' )

  # Project variables
  project =
    # Paths
    paths:
      assets:       'assets/'
      authorAssets: 'assets/widget/'
      bower:        'assets/bower/'
      concat:       'assets/bower/js/concat/'
      config:       'grunt/config/'
      css:          'css/'
      data:         'data/'
      dist:         'dist/'
      js:           'js/'
      tmp:          'tmp/'

  # Measures the time each task takes
  require( 'time-grunt' )( grunt )

  # Load grunt config
  require( 'load-grunt-config' )( grunt, {
    configPath: path.join( process.cwd(), 'grunt/config' )
    data:
      paths: project.paths
      files:
        js:     project.paths.assets       + '{,*/}js/**/*.js'
        coffee: project.paths.assets       + '{,*/}js/**/*.coffee'
        scss:   project.paths.authorAssets + 'scss/**/*.scss'
        svg:    project.paths.authorAssets + 'svg/**/*.svg'
    jitGrunt:
      customTasksDir: 'grunt/tasks'
      staticMappings:
        notify_hooks:  'grunt-notify'
        lineremover:   'grunt-line-remover'
        bower_install: 'grunt-bower-install-task'
        scsslint:      'grunt-scss-lint'
        wpcss:         'grunt-wp-css'
  } )

  # Change the automatic messaging
  grunt.task.run( 'notify_hooks' )
