class PMXMW.WidgetView extends pmxmwBackbone.View

  events:
    'click .pmxWidgetStrap-trigger' : 'showModal'
    'click .pmxWidgetOverlay'       : 'hideModal'
    'click .pmxWidgetModal-trigger' : 'navigationTriggered'

  initialize: ->
    @$window            = selectors.get window
    @$html              = selectors.get 'html'
    @$body              = selectors.get 'body'

    @useCSSTransforms   = @$html.hasClass 'csstransforms'
    @useCSSTransforms3d = @$html.hasClass 'csstransforms3d'

    @dataURL            = "https://cdn.rawgit.com/pixelmoxie/pixelmoxie-marketing-widget/7b578d6/dist/data.xml"
    @themeName          = window.themeInfo.name
    @themeVersion       = window.themeInfo.version

    @isLivePreview      = if (window.location.href.indexOf('/customize/') >= 0) then true else false
    @isFreeTheme        = @$body.hasClass( 'pixelmoxie-free-theme' )
    @showWidget         = @$body.hasClass( 'has-marketing-widget' )
    return

  render: ->
    unless @$body.hasClass( 'has-marketing-widget' )
      @$body.addClass 'has-marketing-widget'

    # coffeelint: disable=max_line_length
    ajaxQuery = "SELECT features-title, support-title, settings-title, themes.theme from xml WHERE url=\"#{@dataURL}\" and themes.theme.title=\"#{@themeName}\""
    ajaxURL = "http://query.yahooapis.com/v1/public/yql?q=" + encodeURIComponent( ajaxQuery ) + "&format=json&callback=?"
    # coffeelint: enable=max_line_length

    $.ajax
      url: ajaxURL
      dataType: 'jsonp'
      type: 'GET'
      cache: true
      success: ( res, status ) =>
        if status is "success" or status is "notmodified"
          data = res.query.results.data
          console.log data

          @setupView()
          @setupEvents()
        return
    return

  setupView: ->
    @.setElement selectors.get( '.pmxWidget' ).last()
    @$tabs       = ($ '.pmxWidgetModal-trigger')
    @$viewport   = ($ '.pmxWidgetModal-viewport')
    @$content    = ($ '.pmxWidgetModal-content')
    @$panels     = ($ '.pmxWidgetModal-section')
    @totalPanels = @$panels.length
    @layout()
    return

  layout: ->
    @$viewport.removeAttr 'style'
    @viewportWidth  = @$viewport.outerWidth()
    @viewportHeight = @$viewport.outerHeight()

    @$content
      .removeAttr 'style'
      .css
        'position' : 'absolute'
        'top'      : 0
        'left'     : 0
        'width'    : @viewportWidth * @totalPanels
        'height'   : @viewportHeight

    pmxmwUnderscore.each @$panels, ( elem, index ) =>
      $panel = $( elem ).removeAttr 'style'
      $panel.css
        'position' : 'absolute'
        'top'      : 0
        'left'     : @viewportWidth * index
        'width'    : @viewportWidth
        'height'   : @viewportHeight
      return
    return

  showModal: ( event ) ->
    event.preventDefault()
    triggeredIndex = ($ event.target).parent().index()
    if triggeredIndex >= 0 and @activeIndex isnt triggeredIndex
      @activeIndex = triggeredIndex
      @navigateTo @activeIndex, true
    @$el.addClass 'showModal'
    return

  hideModal: ->
    @$el.removeClass 'showModal'
    return

  navigationTriggered: ( event ) ->
    event.preventDefault()
    triggeredIndex = ($ event.target).parent().index()
    if triggeredIndex >= 0 and @activeIndex isnt triggeredIndex
      @activeIndex = triggeredIndex
      @navigateTo @activeIndex
    return

  navigateTo: ( index, snap = false ) ->
    @$tabs
      .removeClass 'isActive'
      .eq( index ).addClass 'isActive'

    @$panels
      .removeClass 'isActive'
      .eq( index ).addClass 'isActive'

    offset = @viewportWidth * index * -1

    if snap
      @$content.css { x: offset }
    else
      @$content.transition {
        x: offset
      }, 500, 'cubic-bezier(0.075, 0.820, 0.165, 1.000)'
    return

  setupEvents: ->
    @$window.on 'resize orientationchange', pmxmwUnderscore.debounce (=>
      @layout()
      @navigateTo @activeIndex, true
      return
    ), 150
    return
