as yet unclassified
representationsDo: aBlock for: anObject

	self allSubclassesDo: aBlock.
	SBSubstitution allSubclassesDo: aBlock.
	SBMethodSubstitution allSubclassesDo: aBlock.
	
	"n := anObject class allInstVarNames.
	n size > 0 ifTrue: [
		n do: [:name |
			(anObject respondsTo: name asSymbol) ifTrue: [
				aBlock value: (SBExtractFieldRepresentation new name: name asSymbol)]]]"