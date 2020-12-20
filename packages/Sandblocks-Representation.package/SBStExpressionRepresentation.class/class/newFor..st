as yet unclassified
newFor: anObject

	self flag: #todo. " find a proper way for this. problem:
	- deep copy is generally better, but we want the representation as ast nodes, even if we're a projection 
	- #sourceString produces errors when unknowns are in the expression
	"
	^ (anObject isKindOf: SBSubstitution)
		ifTrue: [anObject sourceString parseAsSandblockWithoutSubstitution]
		ifFalse: [anObject veryDeepCopy]