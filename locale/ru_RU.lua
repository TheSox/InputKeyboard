--This is only an example and dont necessarily fully represent a russian keyboard
function keyLang(self)
	return
		{	
			{--Lower Case
				{ "й", "ц", "у", "к", "е", "н", "г", "ш", "щ", "з", "х", "ъ"},
				{ self.EXTRASPACE, "ф", "ы", "в", "а", "п", "р", "о", "л", "д", "ж", "э"  },
				{ "я", "ч", "с", "м", "и", "т", "ь", "б", "ю", "ё" , self.DEL},
				{ self.UPPER, self.NUMBERS, self.EXTRASPACE,self.EXTRASPACE,self.SPACE, ".", self.HIDE }
			} ,	
			{--Upper Case
				{ "Й", "Ц", "У", "К", "Е", "Н", "Г", "Ш", "Щ", "З", "Х", "Ъ"},
				{ self.EXTRASPACE, "Ф", "Ы", "В", "А", "П", "Р", "О", "Л", "Д", "Ж", "Э" },
				{ "Я", "Ч", "С", "М", "И", "Т", "Ь", "Б", "Ю", "Ё" , self.DEL},
				{ self.LOWER, self.NUMBERS,  self.EXTRASPACE,self.EXTRASPACE,self.SPACE,  ".", self.HIDE }	
			} ,	
			{--Numerical and other
				{ self.EXTRASPACE,"1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
				{ self.EXTRASPACE,"@", "#", "%", "&", "*", "/", "-", "+", "(", ")" },
				{ self.EXTRASPACE, self.EXTRASPACE, self.EXTRASPACE,self.EXTRASPACE, "?", "!", "\"", "'", ":", ";", "," , self.DEL},
				{  self.TEXT, self.EXTRASPACE,self.EXTRASPACE, self.SPACE, ".", self.HIDE   }	
			}
		}
end