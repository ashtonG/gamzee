#Gamzee.js V .01

rowCount = 0
colCount = 0
pages = []
pageChoices = []
names = []
saveNames = []
loadNames = []
#game functions    
choiceEvent = ->
  this

choiceEvent:: =
  eventText: ""
  choices: []

choice = (text, effect, next) ->
  @text = text  if text
  @effect = effect  if effect
  @next = next  if next
  this

choice:: =
  text: "==>"
  effect: ->

  next: ""
  disp: ->
    link = document.createElement("a")
    parentC = this
    pageChoices[pageChoices.length] = parentC
    link.href = "#"
    link.textContent = @text
    link.set "class", "actionLink"
    ltNew = lt.clone()
    ltNew.appendChild link
    if colCount % 3 is 0
      actRow = document.createElement "div"
      rowCount++
      actRow.display = "table-row"
      actRow.id = "row" + rowCount
      actRow.appendChild ltNew
      Actions.appendChild actRow
    else
      $("row" + rowCount).appendChild ltNew
      colCount++
    link.onclick = ->
      pageChoices[Actions.getElements("a").indexOf(this)].effect()
      events[pageChoices[Actions.getElements("a").indexOf(this)].next].eventToPages()  unless pageChoices[Actions.getElements("a").indexOf(this)].next is ""

page = (text, turn) ->
  @text = text
  @turn = turn  unless turn is `undefined`
  this

page:: =
  turn: [new choice(null, ->
    pages.shift().disp()
  )]
  disp: ->
    clear()
    Event.innerHTML = @text
    c = 0
    while c < @turn.length
      @turn[c].disp()
      c++

templatestring = (text) ->
	@raw = text if text
	this

templatestring:: =
	toString: ->
		raw.replace /<%([\w\W]+)%>/, (("$1") -> )

clear = ->
  pageChoices.empty()
  rowCount = 0
  colCount = 0
  Event.textContent = ""
  Actions.textContent = ""

String::flagReplace = ->
  retString = this
  retString = retString.replace("$" + flags[0], character[flags[0]])
  unless @indexOf("$") is -1
    i = 1
    while i < flags.length
      retString = retString.replace("$" + flags[i], descriptions[character[flags[i]]].getRandom())  unless character[flags[i]] is ""
      i++
  retString

Object::eventToPages = ->
  if typeOf(this) is "function"
    this()
  else
    @doIt()  if @doIt?
    txtArray = @eventText.flagReplace().split("</p>")
    until txtArray.length is 0
      pageText = ""
      c = 0
      while c < 2
        prinTxt = txtArray.shift()
        pageText += prinTxt + "<br /><br />"  unless prinTxt is `undefined`
        c++
      unless txtArray.length is 0
        pages.push new page(pageText.toString())
      else
        pages.push new page(pageText.toString(), @choices)
    pages.shift().disp()

Storage::setObject = (key, value) ->
  @setItem key, JSON.encode(value)

Storage::getObject = (key) ->
  JSON.decode @getItem(key)

#Game set up.
preGame = ->
  document.title = $("title").innerHTML = AdventureTitle
  Event = $ "event"
  Actions = $ "actions"
  br = document.createElement "br"
  lt = document.createElement "span"
  lt.textContent = "> "
  events["title"].eventToPages()
  Actions.innerHTML = ""
  namesRaw = localStorage.getObject "taStuckDataRaw"
  if not namesRaw? or namesRaw is {}
    $("rMenu").style.visibility = "hidden"
    $("event").innerHTML += "No save data detected. Select \"New Game\" below to start."
    localStorage.setObject "taStuckData", {}
  else
    Object.each namesRaw, (item, key) ->
      names[names.length] = new choice(key, ->
        character = item
      , "hub")
      c = names.length
      while c < 7
        names[c] = new choice "No data", null, null
        c++

  $("new").onclick = ->
    events["newGame"].eventToPages()

window.addEvent "domready", preGame

