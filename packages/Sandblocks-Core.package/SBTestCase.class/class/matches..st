as yet unclassified
matches: aMethodBlock

	^ (super matches: aMethodBlock) and: [aMethodBlock methodClass isTestClass and: [aMethodBlock selector asSymbol isTestSelector and: [aMethodBlock numArgs = 0]]]