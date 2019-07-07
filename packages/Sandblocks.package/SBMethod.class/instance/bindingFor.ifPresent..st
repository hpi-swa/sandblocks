as yet unclassified
bindingFor: aString ifPresent: aBlock

	signature submorphs detect: [:s | s contents = aString] ifFound: [:s | ^ aBlock value: s] ifNone: [].
	
	self methodClass instVarNames detect: [:name | name = aString] ifFound: [:name | ^ aBlock value: (SBDeclarationForInstanceVariable new contents: name; definingClass: self methodClass)] ifNone: [].
	
	Symbol hasInterned: aString ifTrue: [:sym | | binding |
		binding := self methodClass bindingOf: sym environment: self methodClass environment.
		binding ifNotNil: [^ aBlock value: (SBDeclarationForPoolVariable new contents: aString; binding: binding)]].
	
	^ nil