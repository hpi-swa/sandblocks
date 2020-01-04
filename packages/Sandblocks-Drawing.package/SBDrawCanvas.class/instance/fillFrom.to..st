as yet unclassified
fillFrom: aPoint to: anotherPoint 
	| step |
	self ensurePointReachable: anotherPoint.
	
	WorldState canSurrenderToOS: false.
	step := aPoint = anotherPoint
				ifTrue: [1]
				ifFalse: [1
						/ (anotherPoint dist: aPoint)].
	0
		to: 1
		by: step
		do: [:val | 
			| origin |
			origin := aPoint interpolateTo: anotherPoint at: val.
			stampForm
				displayOn: paintingForm
				at: origin - self position - (stampForm extent // 2)
				clippingBox: paintingForm boundingBox
				rule: Form blend
				fillColor: nil].
	self invalidRect: ((Rectangle encompassing: {aPoint. anotherPoint}) expandBy: stampForm extent // 2)