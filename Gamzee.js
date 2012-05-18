	var rowCount = 0;
	var colCount = 0;
	var pages = [];
	var pageChoices = [];
	var flags = ["name","sex","build"];
	var names = [];
	var saveNames = [];
	var loadNames = [];

//Library of game functions and objects.
	function choiceEvent()
		{return this;}
	
	choiceEvent.prototype= 
		{eventText: "", 
 		choices: []}; 

	function choice(text,effect,next)
		{if(text)
			{this.text = text;}
		if(effect)
			{this.effect = effect;}
		if(next)
			{this.next = next}
		return this;}  

	choice.prototype =
		{text : "==>",
		effect: function(){},
		next: "",
		disp: function()
			{var link = document.createElement("a");
			var parentC = this
			pageChoices[pageChoices.length]=parentC;
			link.href = "#";
			link.textContent = this.text;
			link.set("class","actionLink");
			var ltNew = lt.clone()
			ltNew.appendChild(link);
			if(colCount%3 == 0)
				{var actRow = document.createElement("div");
				rowCount++;
				actRow.display = "table-row";
				actRow.id = "row"+rowCount;
				actRow.appendChild(ltNew);
		 		Actions.appendChild(actRow);}
			else
				{$("row" +rowCount).appendChild(ltNew);
				colCount++;} 
			link.onclick = function()
				{pageChoices[Actions.getElements("a").indexOf(this)].effect();
				if(pageChoices[Actions.getElements("a").indexOf(this)].next!="")
					{events[pageChoices[Actions.getElements("a").indexOf(this)].next].eventToPages();}}}}

	function page(text,turn)
		{this.text =  text;
		if(turn!=undefined)
			{this.turn = turn;}
		return this; }  

	page.prototype = 
		{turn: [new choice(null,function(){pages.shift().disp()})],
		disp: function()
			{clear();
			Event.innerHTML = this.text;
			for(c=0;c<this.turn.length;c++)
				{this .turn[c].disp()}}} 

	String.prototype.flagReplace =function()
		{var retString = this;
		retString = retString.replace("\$" + flags[0], character[flags[0]]);
		if(this.indexOf("$")!=-1)
			{for(i=1;i<flags.length;i++)
				if(character[flags[i]]!="")
					{{retString = retString.replace("\$" + flags[i], descriptions[character[flags[i]]].getRandom())}}}
		return retString;}

	Object.prototype.eventToPages= function()
		{if(typeOf(this)=="function"){
				this();}
			else
				{if(this.doIt!=null){this.doIt();}
				var txtArray = this.eventText.flagReplace().split("</p>");
				while(txtArray.length!=0)
					{var pageText = "";
					for(c=0;c<2;c++)
						{var prinTxt = txtArray.shift();
						if(prinTxt != undefined)
							{pageText += prinTxt + "";}}
						if(txtArray.length!=0)
							{pages.push(new page(pageText.toString()));}
						else
							{pages.push(new page(pageText.toString(), this.choices));}}
			pages.shift().disp();}}

	function clear()
 		{pageChoices.empty(); 
		rowCount = 0;
		colCount = 0;
		Event.textContent ="";
		Actions.textContent = "";}

//Save and Load functions
	Storage.prototype.setObject = function(key, value) 
		{this.setItem(key, JSON.encode(value));}
	 
	Storage.prototype.getObject = function(key) 
	 	{return JSON.decode(this.getItem(key));}

//Game set up.
	function preGame()
		{document.title =$("title").innerHTML = AdventureTitle;
		Event = $("event");
		Actions = $("actions");
		br = document.createElement("br");
		lt = document.createElement("span");
		lt.textContent = "> ";
		events["title"].eventToPages();
		Actions.innerHTML = "";
		namesRaw = localStorage.getObject("taStuckDataRaw");
		if(namesRaw==null||namesRaw=={})
			{$("rMenu").style.visibility="hidden";
			$("event").innerHTML+="No save data detected. Select \"New Game\" below to start.";
		 	localStorage.setObject("taStuckData", {});}
		else
			{Object.each(namesRaw,function(item, key)
				{names[names.length]=new choice
					(key,
					function()
						{character = item;},
					"hub")
					for(c=names.length;c<7;c++)
						{names[c] = new choice("No data",null,null)}})}
		$("new").onclick = function()
			{events["newGame"].eventToPages();}}
	window.addEvent("domready",preGame);
