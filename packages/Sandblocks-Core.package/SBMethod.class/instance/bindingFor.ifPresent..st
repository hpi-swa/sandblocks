as yet unclassified
bindingFor: aString ifPresent: aBlock

	signature childSandblocksDo: [:s | s contents = aString ifTrue: [^ aBlock value: s]].
	
	self instanceVariables detect: [:inst | inst contents = aString] ifFound: [:inst | ^ aBlock value: inst] ifNone: [].
	
	Symbol hasInterned: aString ifTrue: [:sym | | binding |
		binding := self methodClass bindingOf: sym environment: self methodClass environment.
		binding ifNotNil: [^ aBlock value: (SBDeclarationForPoolVariable new contents: aString; binding: binding)]].
	
	^ nil