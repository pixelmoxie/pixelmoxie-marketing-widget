# https://github.com/outaTiME/grunt-replace
module.exports = ( grunt, config ) ->
  css:
    options:
      patterns: [
        # Ensure empty line before comments
        # {
        #   match: /\}\n\/\*/g
        #   replacement: "}\n\n/*"
        # }
      ]
    files: [
      expand: true
      src: [
        '<%= paths.tmp %>style.css'
      ]
    ]
