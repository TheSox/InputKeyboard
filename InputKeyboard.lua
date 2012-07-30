--[[
	InputKeyboard v0.1
	(C) 2012 Mathz Data och Webbutveckling, Mathz Franzén
	Classes for creating an inputbox which activates a keyboard on focus.
	This is intended for use with Gideros Mobile ( http://http://www.giderosmobile.com )
	
	INFO:
	This script is developed by Mathz Franzén. @mathz in the gideros forum
	Thankyou to @evs (gideros forum) for the inspiration to at all realise this could be possible to do.
	@evs's own version of a virtual keyboard can be found at: http://www.giderosmobile.com/forum/discussion/comment/9097#Comment_9097
	It's definitly worth checking out since he only allow Landscape and my script only Portrait!

	Since this is my constitutes my first small step on the Gideros platform, and also one of the first in the world of LUA you can
	expect to find one or two (or >=3) stupid solutions.
	Contributions from other authors are therefore highly appreciated. 
	
	The graphics is inspired by the keyboard on my SGS2, but to 100% created by me in Photoshop and can therefore be redistributed under
	the same conditions as the code (see below)

	LEGAL:
	All types of redistributions and modifications are allowed as long as these criterias are met:
		1. Keep this reference to the original creator and other contributors that is mentioned whitin this document (until now @evs)
		2. Add references to any future contributors
		3. When using this script (modified or unmodified) i would appreciate to have the opportunity to see the final result.
		4. It is encouraged, but not mandatory to make any changes to the script available to the public, for example by sending it to me
		   by email ( my email can be found at http://www.giderosmobile.com/forum/profile/mathz ) or posting the code in the gideros forum

		So in short: never remove contributors, always add and try to be nice to the community by share modifications.

	USAGE:
		Create new inputbox: KeyBoard.new()
		Create new inputbox: InputBox.new(xpos,ypos,width,height)
							 Parameters: xpos:   	 (number)Horiontal position
										 ypos:   	 (number)Vertical position
										 width:  	 (number) Width of inputbox
										 height: 	 (number) Height of inputbox
		
		Set colors:			 InputBox:setBoxColors(background, border, borderWidth, alpha)
							 Parameters: background: (number)Background color
										 border:	 (number)Border color
										 borderWidth:(number)Border width
										 alpha:		 (number)Alpha transparency
		Set focus colors:	 InputBox:setActiveBoxColors(background, border, borderWidth, alpha)
							 Parameters: background: (number)Background color
										 border:	 (number)Border color
										 borderWidth:(number)Border width
										 alpha:		 (number)Alpha transparency
		Get current text:	 InputBox:getText()
		Set text:			 InputBox:setText(text)
							 Parameters: text: 		 (string)The text
		Set max letters		 InputBox:setMaxLetters(maxLetters)
							 Parameters: background: (number)Maximal amount of letters to allow
		Set password field	 InputBox:PasswordField(pField)
							 Parameters: pField: 	 (boolean)True = Inputbox is used as passwordfield
		Set keyboard		 InputBox:SetKeyBoard(keyboard)
							 Parameters: keyboard: 	(KeyBoard)The keyboard to use for this inputbox
	
	KNOWN LIMITIONS/PROBLEMS:
		1. Text can continue outside the boundaries of the box
		2. Only portrait mode is supported.
		3. Developed for Scale mode "Fit width", other scale modes could potentially be a problem.
		4. Developed for width 480px

	TODO:
		Scroll text when passing max width							 
								
]]--
InputBox = Core.class(Sprite)

function InputBox:init(x,y,width,height)
	self.passWordField = false
	self.maxLetters = 1024
	self.width = width
	self.height = height
	self:setPosition(x,y)
	self.background = Shape.new()
	self:addChild(self.background)
	self.active = Shape.new()
	self.active:setVisible(false)
	self:addChild(self.active)
	
	local fontSize = height - (height/9)
	local font = TTFont.new("arial-rounded.TTF",fontSize,true)
	self.textField = TextField.new(font,"")
	self.textField:setPosition(5, 4.5 * fontSize / 5)
	self:addChild(self.textField)
	self.textContent = ""
	self:addEventListener(Event.MOUSE_UP,self.onMouseUp, self)
end

function InputBox:setBoxColors(background, border, borderWidth, alpha)
	self:drawBox(self.background, background, border, borderWidth, alpha)
end

function InputBox:setActiveBoxColors(background, border, borderWidth, alpha)
	self:drawBox(self.active, background, border, borderWidth, alpha)
end

function InputBox:getText()
	return self.textContent
end

function InputBox:setText(text)
	self.textContent = text
	if self.passWordField then
		self.textField:setText(string.rep("*", self.textContent:len()))
	else
		self.textField:setText(text)
	end
end

function InputBox:setMaxLetters(maxLetters)
	self.maxLetters = maxLetters
end

function InputBox:PasswordField(pField)
	self.passWordField = pField
	self.textField:setText(string.rep("*", self.textContent:len()))
end

function InputBox:SetKeyBoard(keyboard)
	self.keyboard = keyboard
end

function InputBox:onMouseUp(event)
	if self:hitTestPoint(event.x, event.y) then
		local event = Event.new("ShowKeyboard")
		event.inputbox = self
		self.keyboard:dispatchEvent(event)
	end
end

function InputBox:Activate()
	self.background:setVisible(false)
	self.active:setVisible(true);
end

function InputBox:DeActivate()
	self.background:setVisible(true)
	self.active:setVisible(false);
end

function InputBox:drawBox(box, background, border, borderWidth, alpha)
	box:setLineStyle(borderWidth, border, alpha)
	box:setFillStyle(Shape.SOLID, background, alpha)
	box:beginPath(Shape.NON_ZERO)
	box:moveTo(0,0)
	box:lineTo(self.width,0)
	box:lineTo(self.width, self.height)
	box:lineTo(0, self.height)
	box:lineTo(0, 0)
	box:endPath()
end

Letter = Core.class(Sprite)
function Letter:init(keyValues,parent,colLeft,rowTop)
	self.BigSmallSwitcher = false
	self.NumericalSwitcher = false
	self.font = parent.font
	self.parent = parent
	self.active = false

	local keyType = 1
	if keyValues[1] == parent.UPPER or keyValues[1] == parent.LOWER or keyValues[1] == parent.DEL or keyValues[1] == parent.TEXT or keyValues[1] == parent.NUMBERS or keyValues[1] == parent.HIDE then
		keyType = 2
	elseif keyValues[1] == parent.SPACE then
		keyType = 3
	end
	self.keyBack = Bitmap.new(parent.keyImages["BACKGROUND"][keyType])
	self.selKey = Bitmap.new(parent.keyImages["HIGHLIGHT"][keyType])
	self.keyBack:setPosition(colLeft,rowTop)
	self.selKey:setPosition(colLeft,rowTop)
	self.selKey:setVisible(false)
	self:addChild(self.keyBack)
	self:addChild(self.selKey)
	self.keyLetters = {}
	self.text = keyValues
	for i=1,3  do
		self.keyLetters[i] = Bitmap.new(parent.keyImages[keyValues[i]])
		if parent.activeLayout == i then
			self.keyLetters[i]:setVisible(true)
		else
			self.keyLetters[i]:setVisible(false)
		end
		self.keyLetters[i]:setPosition(colLeft,rowTop)
		self:addChild(self.keyLetters[i])
	end
	self.keyBack:addEventListener(Event.MOUSE_UP,self.onMouseUp, self)
	self.keyBack:addEventListener(Event.MOUSE_DOWN,self.onMouseDown, self)
end

function Letter:setBMSwitcher(switcher)
	self.BigSmallSwitcher = switcher
end

function Letter:setNUMSwitcher(switcher)
	self.NumericalSwitcher = switcher
end

function Letter:setText()
	for i=1,3  do
		if self.parent.activeLayout == i then
			self.keyLetters[i]:setVisible(true)
		else
			self.keyLetters[i]:setVisible(false)
		end
	end
end

function Letter:onMouseDown(event)
	if self:hitTestPoint(event.x, event.y) then
		self.selKey:setVisible(true)
		self.active = true
		event:stopPropagation()
	end
end

function Letter:onMouseUp(event)
	if self:hitTestPoint(event.x, event.y) and self.active then
		self.active = false
		Timer.delayedCall(100, function()
			self.selKey:setVisible(false)
		end)
		local newLetter = self.text[self.parent.activeLayout]
		if newLetter == self.parent.UPPER or newLetter == self.parent.LOWER then
			self.parent:dispatchEvent(Event.new("switchBM"))
		elseif newLetter == self.parent.NUMBERS or newLetter == self.parent.TEXT then
			self.parent:dispatchEvent(Event.new("switchNUM"))
		elseif newLetter == self.parent.DEL then
			self.parent.inputbox.textField:setText(string.sub(self.parent.inputbox.textField:getText(),1,self.parent.inputbox.textField:getText():len()-1))
			self.parent.inputbox.textContent = string.sub(self.parent.inputbox.textContent,1,self.parent.inputbox.textContent:len()-1)
		elseif newLetter == self.parent.SPACE then
			local letter = " "
			if self.parent.inputbox.passWordField then
				letter = "*"
			end
			self.parent.inputbox.textField:setText(self.parent.inputbox.textField:getText()..letter)
			self.parent.inputbox.textContent = self.parent.inputbox.textContent.." "
		elseif newLetter == self.parent.HIDE then
			self.parent:Hide()
		elseif newLetter == self.parent.EMPTY then
			-- do nothing
		elseif self.parent.inputbox.textField:getText():len() < self.parent.inputbox.maxLetters then
			local letter = newLetter
			if self.parent.inputbox.passWordField then
				letter = "*"
			end
			self.parent.inputbox.textField:setText(self.parent.inputbox.textField:getText()..letter)
			self.parent.inputbox.textContent = self.parent.inputbox.textContent..newLetter
		end	
	elseif self.active then
		self.active = false
		self.selKey:setVisible(false)
		event:stopPropagation()
	end
end

KeyBoard = Core.class(Sprite)

function KeyBoard:init()
	self.TEXT = "TEXT"
	self.NUMBERS = "NUMBERS"
	self.EMPTY = "EMPTY"
	self.HIDE = "HIDE"
	self.SPACE = "SPACE"
	self.DEL = "DEL"
	self.UPPER = "UPPERCASE"
	self.LOWER = "LOWERCASE"
	self.DOT = "DOT"
	self.STAR = "STAR"
	self.DIV = "DIV"
	self.QUESTIONMARK = "QUESTIONMARK"
	self.QUOTE = "QUOTE"
	self.SQUOTE = "SQUOTE"
	self.COLON = "COLON"
	self.SEMICOLON = "SEMICOLON"
	self.COMMA = "COMMA"
	self.EXTRASPACE = "ES"

	-- Load all keyimages
	local singleLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local singleNumeric = "0123456789@%&-+()#!"
	self.keyImages = {}

	for i = 1, singleLetters:len() do
		self.keyImages[singleLetters:sub(i,i):lower()] = Texture.new("img/l"..singleLetters:sub(i,i)..".png")
		self.keyImages[singleLetters:sub(i,i):upper()] = Texture.new("img/u"..singleLetters:sub(i,i)..".png")
	end
	for i = 1, singleNumeric:len() do
		self.keyImages[singleNumeric:sub(i,i)] = Texture.new("img/"..singleNumeric:sub(i,i)..".png")
	end

	self.keyImages[self.UPPER] = Texture.new("img/"..self.UPPER..".png")
	self.keyImages[self.DEL] = Texture.new("img/"..self.DEL..".png")
	self.keyImages["."] = Texture.new("img/"..self.DOT..".png")
	self.keyImages[self.SPACE] = Texture.new("img/"..self.SPACE..".png")
	self.keyImages[self.HIDE] = Texture.new("img/"..self.HIDE..".png")
	self.keyImages[self.NUMBERS] = Texture.new("img/"..self.NUMBERS..".png")
	self.keyImages[self.EMPTY] = Texture.new("img/"..self.EMPTY..".png")
	self.keyImages[self.LOWER] = Texture.new("img/"..self.LOWER..".png")	
	self.keyImages[self.TEXT] = Texture.new("img/"..self.TEXT..".png")	
	self.keyImages["'"] = Texture.new("img/"..self.SQUOTE..".png")
	self.keyImages[":"] = Texture.new("img/"..self.COLON..".png")
	self.keyImages[";"] = Texture.new("img/"..self.SEMICOLON..".png")
	self.keyImages[","] = Texture.new("img/"..self.COMMA..".png")
	self.keyImages["?"] = Texture.new("img/"..self.QUESTIONMARK..".png")
	self.keyImages["\""] = Texture.new("img/"..self.QUOTE..".png")
	self.keyImages["/"] = Texture.new("img/"..self.DIV..".png")
	self.keyImages["*"] = Texture.new("img/"..self.STAR..".png")
	self.keyImages["BACKGROUND"] = {}
	self.keyImages["HIGHLIGHT"] = {}
	self.keyImages["BACKGROUND"][1] = Texture.new("img/key.png")
	self.keyImages["HIGHLIGHT"][1] = Texture.new("img/keyHigh.png")
	self.keyImages["BACKGROUND"][2] = Texture.new("img/key2.png")
	self.keyImages["HIGHLIGHT"][2] = Texture.new("img/keyHigh2.png")
	self.keyImages["BACKGROUND"][3] = Texture.new("img/key3.png")
	self.keyImages["HIGHLIGHT"][3] = Texture.new("img/keyHigh3.png")

	self.activeLayout = 1
	self.keys = 
	{	
		{--Lower Case
			{ "q", "w", "e", "r", "t", "y", "u", "i", "o", "p" },
			{ self.EXTRASPACE, "a", "s", "d", "f", "g", "h", "j", "k", "l" },
			{ self.UPPER, "z", "x", "c", "v", "b", "n", "m", self.DEL },
			{ self.NUMBERS, "@", self.SPACE, ".", self.HIDE }
		} ,	
		{--Upper Case
			{ "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P" },
			{ self.EXTRASPACE, "A", "S", "D", "F", "G", "H", "J", "K", "L" },
			{ self.LOWER, "Z", "X", "C", "V", "B", "N", "M", self.DEL },
			{ self.NUMBERS, "@", self.SPACE, ".", self.HIDE }
			
		} ,	
		{--Numerical and other
			{ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
			{ self.EXTRASPACE, "#", "%", "&", "*", "/", "-", "+", "(", ")" },
			{ self.EMPTY, "?", "!", "\"", "'", ":", ";", ",", self.DEL },
			{ self.TEXT, "@", self.SPACE, ".", self.HIDE   }	
		}
	}

	local tmpKey = Bitmap.new(self.keyImages["BACKGROUND"][1])
	self.keyWidth = tmpKey:getWidth()
	self.keyHeight =tmpKey:getHeight()
	tmpKey = nil

	self.hSpacing = (application:getLogicalWidth() - self.keyWidth * 10) / 11 
	self.vSpacing = self.hSpacing - 1
	self.big = false
	self.numerical = false
	self.rows = #self.keys[1]
	self.letterHolder = {}
	self.topBorder = application:getLogicalHeight() + application:getLogicalTranslateY() / application:getLogicalScaleY() - (self.rows * self.keyHeight + (self.rows + 1) * self.vSpacing)
	self:setPosition(0,application:getLogicalHeight() + application:getLogicalTranslateY() / application:getLogicalScaleY())
	self.movieFrames = (application:getLogicalHeight() + application:getLogicalTranslateY() / application:getLogicalScaleY() - self.topBorder) / 20

	self.background = Shape.new()
	self.background:setFillStyle(Shape.SOLID, 0x0a0a0a)
	self.background:beginPath(Shape.NON_ZERO)

	self.background:moveTo(0, 0)
	self.background:lineTo(application:getLogicalWidth(), 0)
	self.background:lineTo(application:getLogicalWidth(), application:getLogicalHeight())
	self.background:lineTo(0, application:getLogicalHeight()) 
	self.background:lineTo(0, 0)
	self.background:endPath()
	self:addChild(self.background)
	self:addEventListener("switchBM", self.onBMSwitch, self)
	self:addEventListener("switchNUM", self.onNUMSwitch, self)
	self:addEventListener("ShowKeyboard", self.onShow, self)
	
	print(application:getLogicalScaleX(), application:getLogicalScaleY())
end

function KeyBoard:onBMSwitch()
	if self.big then
		self.activeLayout = 1
	else
		self.activeLayout = 2
	end
	self.big = not self.big
	for i,k in pairs(self.letterHolder) do self.letterHolder[i]:setText() end
end

function KeyBoard:onNUMSwitch()
	if self.numerical then
		if self.big then
			self.activeLayout = 2
		else
			self.activeLayout = 1
		end
	else
		self.activeLayout = 3
	end
	self.numerical = not self.numerical
	for i,k in pairs(self.letterHolder) do self.letterHolder[i]:setText() end
end

function KeyBoard:Create()
	local colLeft =  0
	local rowTop = - self.keyHeight
	self.inputbox = nil
	local counter = 0
	
	for rowNo = 1, 4, 1 do
		rowTop = rowTop + self.vSpacing + self.keyHeight
		colLeft =  self.hSpacing
		for i,letter in pairs(self.keys[1][rowNo]) do
			counter = counter + 1
			local keyValues = {}
			for b=1,3,1 do
				keyValues[b]= self.keys[b][rowNo][i]
			end

			if self.keys[1][rowNo][i] == self.EXTRASPACE then
				colLeft = colLeft + (self.keyWidth +self.hSpacing) / 2
			else
				self.letterHolder[counter] = Letter.new(keyValues,self,colLeft,rowTop)
				self:addChild(self.letterHolder[counter])
				colLeft = colLeft + self.letterHolder[counter]:getWidth() + self.hSpacing
			end
		end
	end
end

function KeyBoard:Hide() 
	MovieClip.new{{1, self.movieFrames, self, {y = {self.topBorder, application:getLogicalHeight() + application:getLogicalTranslateY() / application:getLogicalScaleY(),  "linear"}}}}
	self.inputbox:DeActivate()
end

function KeyBoard:Show()
	if math.floor(self:getY()) ~= math.floor(self.topBorder) then
		MovieClip.new{{1, self.movieFrames, self, {y = {application:getLogicalHeight() + application:getLogicalTranslateY() / application:getLogicalScaleY(), self.topBorder,  "linear"}}}}
	end
	if self.inputbox ~= nil then
		self.inputbox:Activate()
	end
end

function KeyBoard:onShow(event)
	if self.inputbox ~= nil then
		self.inputbox:DeActivate()
	end
	self.inputbox = event.inputbox
	self:Show()
end