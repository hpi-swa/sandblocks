removing
removeComponentByName: aString

	self componentRegistryCategoriesDo: [:categoryName :entries | self removeComponentByName: aString inCategory: categoryName ifAbsent: []]