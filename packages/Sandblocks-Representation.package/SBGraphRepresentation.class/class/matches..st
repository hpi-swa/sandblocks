as yet unclassified
matches: anObject

	^ anObject isCollection and: [anObject notEmpty and: [(anObject isKindOf: CompiledCode) not and: [anObject allSatisfy: #isNumber]]]