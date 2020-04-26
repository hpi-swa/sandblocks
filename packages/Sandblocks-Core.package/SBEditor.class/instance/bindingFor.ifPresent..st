accessing
bindingFor: aString ifPresent: aBlock

	Symbol hasInterned: aString ifTrue: [:sym | | binding class |
		class := self selectedArtefact relatedClass.
		binding := class bindingOf: sym environment: class environment.
		binding ifNotNil: [^ aBlock value: ((SBName poolDeclaration: aString) binding: binding)]].
	
	^ nil