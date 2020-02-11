as yet unclassified
matches: aMethodBlock

	^ aMethodBlock methodClass isTestClass and: [aMethodBlock selector asSymbol isTestSelector and: [aMethodBlock arguments isEmpty]]