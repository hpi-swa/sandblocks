as yet unclassified
send: aBlock

	"aBlock actualReceiver guessClassExpensive
		ifNotNil: [:class |
			(class lookupSelector: aBlock selector asSymbol) ifNotNil: [:m |
				self addMorphBack: m asSandblock]]."
	
	self addMorphBack: aBlock veryDeepCopy.
	
	self addMorphBack: (self systemNavigation allImplementorsOf: aBlock selector asSymbol) first compiledMethod asSandblock