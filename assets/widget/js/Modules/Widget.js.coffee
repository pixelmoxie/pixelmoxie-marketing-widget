class PMXMW.WidgetView extends pmxmwBackbone.View

  events:
    'click .pmxWidgetStrap-trigger' : 'showModal'
    'click .pmxWidgetOverlay'       : 'hideModal'
    'click .pmxWidgetModal-trigger' : 'navigationTriggered'
    'change input'                  : 'demoSettingTriggered'

  initialize: ->
    @$window            = selectors.get window
    @$html              = selectors.get 'html'
    @$body              = selectors.get 'body'

    @useCSSTransforms   = @$html.hasClass 'csstransforms'
    @useCSSTransforms3d = @$html.hasClass 'csstransforms3d'

    @baseURL            = window.themeInfo.widgetBaseURL
    # @dataURL            = "#{@baseURL}data.xml"
    @dataURL            = "https://cdn.rawgit.com/pixelmoxie/pixelmoxie-marketing-widget/834dedc/dist/data.xml"
    @cssURL             = "#{@baseURL}pmxmw.css"
    @themeName          = window.themeInfo.name
    @themeVersion       = window.themeInfo.version

    @isLivePreview      = if (window.location.href.indexOf('/customize/') >= 0) then true else false
    @isFreeTheme        = @$body.hasClass 'pixelmoxie-free-theme'
    @showWidget         = @$body.hasClass 'has-marketing-widget'
    return

  render: ->
    unless @$body.hasClass( 'has-marketing-widget' )
      @$body.addClass 'has-marketing-widget'

    # coffeelint: disable=max_line_length
    ajaxQuery = "SELECT features-title, support-title, settings-title, demo-settings-title, themes.theme from xml WHERE url=\"#{@dataURL}\" and themes.theme.title=\"#{@themeName}\""
    ajaxURL = "http://query.yahooapis.com/v1/public/yql?q=" + encodeURIComponent( ajaxQuery ) + "&format=json&callback=?"
    # coffeelint: enable=max_line_length

    $.ajax
      url: ajaxURL
      dataType: 'jsonp'
      type: 'GET'
      cache: true
      success: ( res, status ) =>
        if res.error or res.query is undefined
          console.log "PMXMW: Error loading data."
          return

        if status is "success" or status is "notmodified"
          data = res.query.results.data
          @timeInMs = Date.now()
          @buildWidget data
          @setupView()
          @setupEvents()
          @loadCSS()
        return
    return

  loadCSS: ->
    @stylesheet = loadCSS @cssURL
    onloadCSS @stylesheet, =>
      if @$el.is ':hidden' then @$el.css { 'display': 'block' }
      pmxmwUnderscore.delay (=>
        @layout()
        return
      ), 150
      console.log "PMXMW: Stylesheet loaded in #{(Date.now() - @timeInMs) / 1000}s."
      return
    return

  buildWidget: ( data ) ->
    # coffeelint: disable=max_line_length
    widgetMarkup = """
    <div class="pmxWidget" style="display: none;">
      <div class="pmxWidgetModal">
        <div class="pmxWidgetModal-contentWrap">
          <header class="pmxWidgetModal-header">
            <h1 class="pmxWidgetModal-themeName">#{data.themes.theme.title}</h1>
          </header>
          <nav class="pmxWidgetModal-nav">
            <ul class="pmxWidgetModal-tabs">
              <li class="pmxWidgetModal-tab">
                <a class="pmxWidgetModal-trigger isActive" href="#pmxw-features">#{data['features-title']}</a>
              </li>
              <li class="pmxWidgetModal-tab">
                <a class="pmxWidgetModal-trigger" href="#pmxw-support">#{data['support-title']}</a>
              </li>
              #{ if data.themes.theme.modal.settings then """
              <li class="pmxWidgetModal-tab">
                <a class="pmxWidgetModal-trigger" href="#pmxw-settings">#{data['settings-title']}</a>
              </li>
              """}
            </ul>
          </nav>
          <div class="pmxWidgetModal-viewport">
            <div class="pmxWidgetModal-content">
              <div id="pmxw-features" class="pmxWidgetModal-section pmxWidgetModal-featuresSection isActive">
                <div class="pmxWidgetModal-sectionBody pmxWidgetModal-rte">
                  #{data.themes.theme.modal.features.description}
                </div>
              </div>
              <div id="pmxw-support" class="pmxWidgetModal-section pmxWidgetModal-supportSection">
                <div class="pmxWidgetModal-sectionBody pmxWidgetModal-rte">
                  #{data.themes.theme.modal.support.description}
                </div>
              </div>
              #{ if data.themes.theme.modal.settings then """
              <div id="pmxw-settings" class="pmxWidgetModal-section pmxWidgetModal-settingsSection">
                <div class="pmxWidgetModal-sectionBody pmxWidgetModal-rte">
                  #{data.themes.theme.modal.settings.description}
                  <div class="pmxWidgetModal-controls"></div>
                </div>
              </div>
              """ }
            </div>
          </div>
          <footer class="pmxWidgetModal-footer"></footer>
        </div>
      </div><!-- .pmxWidgetModal -->
      <div class="pmxWidgetOverlay">
        <div class="pmxWidgetOverlay-close">
          <svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 36 36">
            <path d="M26.1,12l-6,6l6,6L24,26.1l-6-6l-6,6L9.9,24l6-6l-6-6L12,9.9l6,6l6-6L26.1,12z"/>
          </svg>
        </div>
      </div><!-- .pmxWidgetOverlay -->
        <div class="pmxWidgetStrap">
          <div class="pmxWidgetStrap-segment pmxWidgetStrap-branding">
            <a class="pmxWidgetStrap-logo" href="http://www.pixelmoxie.net" target="_blank">
              <svg xmlns="http://www.w3.org/2000/svg" width="56" height="40" viewBox="0 0 56 40">
                <path d="M52.6 3.4C50.3 1.1 47.3 0 44.4 0c-3 0-5.9 1.1-8.2 3.4L28 11.6l-8.2-8.2C17.6 1.1 14.6 0 11.6 0S5.7 1.1 3.4 3.4C1.1 5.7 0 8.6 0 11.6c0 3 1.1 5.9 3.4 8.2L20.6 37c4.1 4.1 10.7 4.1 14.7 0l17.2-17.2c2.2-2.2 3.3-5 3.4-7.9.1-3.1-1-6.2-3.3-8.5zM30.5 18.9c1.4 1.4 1.4 3.6 0 4.9-.6.7-1.5 1-2.5 1s-1.8-.4-2.5-1c-1.4-1.4-1.4-3.6 0-4.9l2.5-2.5 2.5 2.5zM50.1 5.8c3.2 3.2 3.2 8.3 0 11.5L32.9 34.5c-2.7 2.7-7.1 2.7-9.8 0L5.9 17.3C2.7 14.1 2.7 9 5.9 5.8c3.2-3.2 8.3-3.2 11.5 0l8.2 8.2-2.5 2.5c-1.3 1.3-2 3.1-2 4.9s.7 3.6 2 4.9c2.7 2.7 7.1 2.7 9.8 0 1.3-1.3 2-3.1 2-4.9 0-1.8-.7-3.6-2-4.9L30.5 14l8.2-8.2c3.1-3.1 8.2-3.1 11.4 0z"></path>
              </svg>
            </a>
          </div>
          <div class="pmxWidgetStrap-segment pmxWidgetStrap-title">
            <h4 class="pmxWidgetStrap-themeName">#{data.themes.theme.title}</h4>
          </div>
          <div class="pmxWidgetStrap-segment pmxWidgetStrap-actions">
            <a class="pmxWidgetStrap-cta" href="javascript:;" target="_blank">Buy Now<span class="pmxWidgetStrap-cartIcon"><svg xmlns="http://www.w3.org/2000/svg" width="13" height="12" viewBox="0 0 13 12"><path d="M4 1c-.1-.6-.6-1-1.2-1H1C.5 0 0 .4 0 1s.4 1 1 1h1l.8 4.2c.1.5.6.8 1 .8h7.4c.5 0 .9-.3 1-.8l.8-4c.1-.3 0-.6-.2-.8-.2-.3-.5-.4-.8-.4H4z"></path><circle cx="10.5" cy="10.5" r="1.5"></circle><circle cx="4.5" cy="10.5" r="1.5"></circle></svg></span></a>
          </div>
          <div class="pmxWidgetStrap-segment pmxWidgetStrap-nav">
            <ul class="pmxWidgetStrap-menu">
              <li class="pmxWidgetStrap-menuItem">
                <a class="pmxWidgetStrap-trigger" href="#pmx-features">#{data['features-title']}</a>
              </li>
              <li class="pmxWidgetStrap-menuItem">
                <a class="pmxWidgetStrap-trigger" href="#pmx-support">#{data['support-title']}</a>
              </li>
              #{ if data.themes.theme.modal.settings then """
              <li class="pmxWidgetStrap-menuItem" data-pmw-balloon="#{data['demo-settings-title']}" data-pmw-balloon-pos="right-edge">
                <a class="pmxWidgetStrap-trigger pmxWidgetStrap-trigger--settings" href="#pmx-settings">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16">
                    <path d="M15 4h-2c-.6 0-1 .4-1 1s.4 1 1 1h2c.6 0 1-.4 1-1s-.4-1-1-1zm-6 6H7c-.6 0-1 .4-1 1s.4 1 1 1h2c.6 0 1-.4 1-1s-.4-1-1-1zM3 6H1c-.6 0-1 .4-1 1s.4 1 1 1h2c.6 0 1-.4 1-1s-.4-1-1-1zm11 1c-.6 0-1 .4-1 1v7c0 .6.4 1 1 1s1-.4 1-1V8c0-.6-.4-1-1-1zm0-4c.6 0 1-.4 1-1V1c0-.6-.4-1-1-1s-1 .4-1 1v1c0 .6.4 1 1 1zM8 9c.6 0 1-.4 1-1V1c0-.6-.4-1-1-1S7 .4 7 1v7c0 .6.4 1 1 1zm0 4c-.6 0-1 .4-1 1v1c0 .6.4 1 1 1s1-.4 1-1v-1c0-.6-.4-1-1-1zM2 9c-.6 0-1 .4-1 1v5c0 .6.4 1 1 1s1-.4 1-1v-5c0-.6-.4-1-1-1zm0-4c.6 0 1-.4 1-1V1c0-.6-.4-1-1-1S1 .4 1 1v3c0 .6.4 1 1 1z"></path>
                  </svg>
                </a>
              </li>
              """ }
            </ul>
          </div>
        </div><!-- .pmxWidgetStrap -->
    </div><!-- .pmxWidget -->
    """
    # coffeelint: enable=max_line_length
    @$body.append widgetMarkup
    pmxmwUnderscore.defer =>
      unless sessionStorage.getItem 'pmx-settings-clicked'
        (@$ '.pmxWidgetStrap-trigger--settings').addClass 'ripple'
      @buildSettingsControls data.themes.theme.modal.settings.controls
      return
    return

  buildSettingsControls: ( controls ) ->
    markup = ""
    pmxmwUnderscore.each controls, ( instance, key ) =>
      if 'group' is key
        if pmxmwUnderscore.isArray instance
          pmxmwUnderscore.each instance, ( group, key ) =>
            markup += @getControlGroup group
            return
        else
          markup += @getControlGroup instance
      else if 'control' is key
        pmxmwUnderscore.each instance, ( control, key ) =>
          markup += @getControl control
          return
      return
    pmxmwUnderscore.defer =>
      (@$ '.pmxWidgetModal-controls').html markup
      return
    return

  getControlGroup: ( group ) ->
    markup = ""
    markup += "<div class=\"pmxWidgetModal-controlGroup\">\n"
    if group.title then markup += "<h3 class=\"pmxWidgetModal-controlGroupTitle\">#{group.title}</h3>\n"
    pmxmwUnderscore.each group.control, ( control ) =>
      markup += @getControl control
      return
    markup += "</div>\n"
    return markup

  getControl: ( control ) ->
    if 'checkbox' is control.type
      markup = """
      <div class="pmxWidgetModal-controlWrap">
        <label class="pmxWidgetModal-control pmxWidgetModal-switch">#{control.content}
          <input type="checkbox" id="#{control.name}"#{ if control.checked then ' checked="checked"' else '' }/>
          <div class="pmxWidgetModal-controlIndicator"><small></small></div>
        </label>\n
      </div>\n
      """
    else if 'radio' is control.type
      markup = """
      <div class="pmxWidgetModal-controlWrap">
        <label class="pmxWidgetModal-control pmxWidgetModal-radio">#{control.content}
          <input type="radio" id="#{control.id}" name="#{control.name}"#{ if control.checked then ' checked="checked"' else '' }/>
          <div class="pmxWidgetModal-controlIndicator"><small></small></div>
        </label>
      </div>\n
      """
    else if 'swatch' is control.type
      markup = """
      <div class="pmxWidgetModal-controlWrap pmxWidgetModal-swatchWrap">
        <label class="pmxWidgetModal-control pmxWidgetModal-swatch">
          <input type="radio" id="#{control.id}" name="#{control.name}"#{ if control.checked then ' checked="checked"' else '' }/>
          <div class="pmxWidgetModal-controlIndicator" style="background-color: #{control.content};"><small>#{control.content}</small></div>
        </label>
      </div>\n
      """
    else
      return ""
    return markup

  setupView: ->
    @.setElement selectors.get( '.pmxWidget' ).last()
    @$tabs       = (@$ '.pmxWidgetModal-trigger')
    @$viewport   = (@$ '.pmxWidgetModal-viewport')
    @$content    = (@$ '.pmxWidgetModal-content')
    @$panels     = (@$ '.pmxWidgetModal-section')
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

    console.log "PMXMW: Viewport size is #{@viewportWidth}x#{@viewportHeight}"
    return

  showModal: ( event ) ->
    event.preventDefault()
    $target = $ event.target
    triggeredIndex = $target.parent().index()

    if $target.hasClass 'ripple'
      $target.removeClass 'ripple'
      storageKey = $target.attr('href').replace(/[^a-zA-Z 0-9\-]/, '') + '-clicked'
      sessionStorage.setItem storageKey, true

    if triggeredIndex >= 0 and @activeIndex isnt triggeredIndex
      @activeIndex = triggeredIndex
      @navigateTo @activeIndex, true

    @$el.addClass 'showModal'
    @$body.addClass 'show-marketing-modal'
    return

  hideModal: ->
    @$el.removeClass 'showModal'
    @$body.removeClass 'show-marketing-modal'
    return

  hideStrap: ->
    @$el.addClass 'hideStrap' unless @$el.hasClass 'hideStrap'
    return

  showStrap: ->
    @$el.removeClass 'hideStrap' if @$el.hasClass 'hideStrap'
    return

  navigationTriggered: ( event ) ->
    event.preventDefault()
    $target = $ event.target
    triggeredIndex = $target.parent().index()
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

  demoSettingTriggered: ( event ) ->
    eventHandle = String( event.target.name || event.target.id ).toLowerCase().replace(/ /g, '_')
    eventValue  = if 'checkbox' is event.target.type then event.target.checked else String( event.target.id ).toLowerCase()
    @$el.trigger "pmxmw:#{eventHandle}", [ eventValue ]
    return

  setupEvents: ->
    @$window.on 'resize orientationchange', pmxmwUnderscore.debounce (=>
      @layout()
      @navigateTo @activeIndex, true
      return
    ), 150

    # selectors.get( document ).on 'pmxmw:color_scheme pmxmw:divider_style', ( event, val ) ->
    #   console.log "#{event.type}: #{val}"
    #   return

    pmxmwUnderscore.delay (=>
      (@$ '.pmxWidgetStrap-trigger--settings').trigger 'click'
    ), 500
    return
