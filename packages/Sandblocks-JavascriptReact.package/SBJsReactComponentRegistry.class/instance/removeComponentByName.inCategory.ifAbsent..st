removing
removeComponentByName: aString inCategory: anotherString ifAbsent: aBlock

	(self componentRegistry at: anotherString)
		removeKey: aString
		ifAbsent: aBlock