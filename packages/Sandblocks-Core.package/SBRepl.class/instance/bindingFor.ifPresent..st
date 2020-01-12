artefact protocol
bindingFor: aString ifPresent: aBlock

	bindings submorphs detect: [:b | b contents = aString] ifFound: [:v | ^ aBlock value: v].
	
	Symbol hasInterned: aString ifTrue: [:sym | | binding |
		binding := self methodClass bindingOf: sym environment: self methodClass environment.
		binding ifNotNil: [^ aBlock value: (SBDeclarationForPoolVariable new contents: aString; binding: binding)]].
	
	^ nil