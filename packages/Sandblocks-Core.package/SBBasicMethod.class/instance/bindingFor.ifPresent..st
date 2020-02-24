as yet unclassified
bindingFor: aString ifPresent: aBlock

	self argumentsDo: [:a | a contents = aString ifTrue: [^ aBlock value: a]].

	self instanceVariables detect: [:inst | inst contents = aString] ifFound: [:inst | ^ aBlock value: inst] ifNone: [].
	
	Symbol hasInterned: aString ifTrue: [:sym | | binding |
		binding := self methodClass bindingOf: sym environment: self methodClass environment.
		binding ifNotNil: [^ aBlock value: (SBDeclarationForPoolVariable new contents: aString; binding: binding)]].
	
	^ nil