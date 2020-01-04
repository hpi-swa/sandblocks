as yet unclassified
new

	^ self == SBName ifTrue: [self error: 'this class is abstrast'] ifFalse: [super new]