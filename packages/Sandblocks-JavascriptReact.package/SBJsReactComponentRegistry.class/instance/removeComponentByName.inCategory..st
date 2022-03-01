removing
removeComponentByName: aString inCategory: anotherString

	self
		removeComponentByName: aString
		inCategory: anotherString
		ifAbsent: [self signal: 'Could not find ', aString, ' in category ', anotherString]