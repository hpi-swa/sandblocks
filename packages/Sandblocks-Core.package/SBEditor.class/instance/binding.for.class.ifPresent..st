accessing
binding: aString for: block class: aClass ifPresent: aBlock

	Symbol hasInterned: aString ifTrue: [:sym | | binding |
		binding := aClass bindingOf: sym environment: aClass environment.
		binding ifNotNil: [^ aBlock value: ((SBName poolDeclaration: aString) binding: binding)]].
	
	^ nil