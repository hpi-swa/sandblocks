as yet unclassified
bindingFor: aString ifPresent: aBlock

	self argumentsDo: [:a | a contents = aString ifTrue: [^ aBlock value: a]].

	self instanceVariables detect: [:inst | inst contents = aString] ifFound: [:inst | ^ aBlock value: inst] ifNone: [].
	
	
	^ super bindingFor: aString ifPresent: aBlock