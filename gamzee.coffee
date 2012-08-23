#gamzee v0.1.1
eventsArray = {}
characters = []
Storage::setObject = (key, value) ->
  @setItem key, JSON.encode(value)

Storage::getObject = (key) ->
  $.parseJSON @getItem(key)

String::replaceFlags = ->
  if @match(/<%.+?%>/) or @match(/<%=.+?%>/)
    str = ""
    if @match(/<%=.+?%>/)
      str = @replace(/<%=(.+?)%>/g, (match, p1) ->
        eval(p1)) #EVAL IS EVIL but I need it so bad to handle string functions.
    else str = this
    if str.match(/<%.+?%>/)
      str = str.replace(/<%(.+?)%>/g, (match, p1)->
        character[p1])
    return str
  else this

page =
  title: (str) ->
    if str?
      $("#title").text str
    else
      $("#title").text()
  event: ->
    $ "#event"
  actions: ->
    $ "#actions"
  eventDisplay: (dEvent) ->
    page.event().empty()
    page.actions().empty()
    lines = $(dEvent.eventText.replaceFlags().toString()).filter("p")
    lines.slice(0,breakAt).each (index, element) ->
      page.event().append element
    rest = $ "<div/>"
    lines.slice(breakAt).each (index, element) ->
      rest.append element
    if lines.length > breakAt
      page.actions().append new choice("==>",null, new event(rest.html(), dEvent.choices)).link()
    else
      choiceString = ""
      if dEvent.choices?
        for choiceI in dEvent.choices
          page.actions().append choiceI.link()
class event
  constructor: (@eventText,@choices) ->

class choice
  constructor: (@text, @action, @destination) ->

  link: ->
    cho = this
    $("<a href='#'>#{@text}</a>").click cho, ->
      cho.action() if cho.action?
      if typeof(cho.destination) is "string"
        console.log cho.destination
        page.eventDisplay eventsArray[cho.destination]
      else if cho.destination.eventText?
        page.eventDisplay cho.destination
      else throw "NotEventError"

class playerCharacter
  constructor: (@name, @stats) ->

readyUp = ->
  document.title = AdventureTitle
  page.title AdventureTitle
  for own key, value of events
    eventsArray[key]=new event(value.eventText, value.choices)
  page.eventDisplay eventsArray["title"]
  $("#new").click ->
    page.eventDisplay eventsArray["newGame"]

$ readyUp
