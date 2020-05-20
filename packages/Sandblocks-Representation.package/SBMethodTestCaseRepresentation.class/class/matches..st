as yet unclassified
matches: anObject

	^ anObject isCompiledMethod and: [anObject selector isTestSelector and: [anObject selector isUnary and: [anObject methodClass isTestClass]]]