*Sandblocks-Core
line: aSideSymbol do: aBlock

	aSideSymbol = #left ifTrue: [^ aBlock value: self topLeft value: self bottomLeft].
	aSideSymbol = #right ifTrue: [^ aBlock value: self topRight value: self bottomRight].
	aSideSymbol = #top ifTrue: [^ aBlock value: self topLeft value: self topRight].
	aSideSymbol = #bottom ifTrue: [^ aBlock value: self bottomLeft value: self bottomRight].
	self error: 'invalid edge'