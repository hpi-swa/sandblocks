artefact protocol
bindingFor: aString class: aClass ifPresent: aBlock

	bindings submorphs detect: [:b | b contents = aString] ifFound: [:v | ^ aBlock value: v].
	
	Symbol hasInterned: aString ifTrue: [:sym | | binding |
		binding := aClass bindingOf: sym environment: self methodClass environment.
		binding ifNotNil: [^ aBlock value: ((SBName poolDeclaration: aString) binding: binding)]].
	
	^ nil