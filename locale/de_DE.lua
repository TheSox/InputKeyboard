--This is only an example and dont necessarily fully represent a german keyboard
function keyLang(self)
	return
		{	
			{--Lower Case
				{ "q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ü"},
				{ "a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä" },
				{ self.EXTRASPACE, self.UPPER, "y", "x", "c", "v", "b", "n", "m", self.DEL },
				{ self.NUMBERS, self.EXTRASPACE,self.EXTRASPACE,self.SPACE, ".", self.HIDE }
			} ,	
			{--Upper Case
				{ "Q", "W", "E", "R", "T", "Z", "U", "I", "O", "P", "Ü"},
				{ "A", "S", "D", "F", "G", "H", "J", "K", "L", "Ö", "Ä" },
				{ self.EXTRASPACE, self.LOWER, "Y", "X", "C", "V", "B", "N", "M", self.DEL },
				{ self.NUMBERS,  self.EXTRASPACE,self.EXTRASPACE,self.SPACE,  ".", self.HIDE }	
			} ,	
			{--Numerical and other
				{ self.EXTRASPACE,"1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
				{ self.EXTRASPACE,"@", "#", "%", "&", "*", "/", "-", "+", "(", ")" },
				{ self.EXTRASPACE, self.EXTRASPACE, self.EXTRASPACE,self.EXTRASPACE, "?", "!", "\"", "'", ":", ";", ",", self.DEL },
				{ self.TEXT, self.EXTRASPACE,self.EXTRASPACE, self.SPACE, ".", self.HIDE   }	
			}
		}
end