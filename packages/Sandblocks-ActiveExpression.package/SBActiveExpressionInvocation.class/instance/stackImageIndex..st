accessing
stackImageIndex: aNumber

	aNumber = currentStackIndex ifTrue: [^ self].
	
	self balloonText: ((stack collectWithIndex: [:frame :index |
		index = aNumber
			ifTrue: [frame stringRepresentation asText allBold]
			ifFalse: [frame stringRepresentation asText]]) fold: [:a :b | a, String cr, b]).
		
	currentStackIndex := aNumber.
	image image: (stack at: aNumber) imageForm