as yet unclassified
matches: anObject

	true ifTrue: [^ false].
	^ anObject isCollection and: [anObject notEmpty and: [(anObject isKindOf: CompiledCode) not and: [anObject allSatisfy: #isNumber]]]