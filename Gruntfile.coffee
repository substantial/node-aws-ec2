module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-shell'
  grunt.loadNpmTasks 'grunt-mocha-test'

  grunt.initConfig

    mochaTest:
      run:
        src: ['spec/helper.coffee', 'spec/**/*_spec.coffee']
        options:
          clearRequireCache: true
      ci:
        options:
          reporter: 'mocha-teamcity-reporter'
        src: ['spec/helper.coffee', 'spec/**/*_spec.coffee']

    watch:
      test:
        options:
          spawn: true
          atBegin: true
        files: ['src/**/[a-z]*.coffee', 'spec/**/[a-z]*.coffee']
        tasks: ['mochaTest']

  grunt.registerTask('default', 'watch')
