as yet unclassified
matches: aBlock

	^ aBlock selector = 'halt' or: [aBlock receiver isName and: [aBlock receiver contents = 'SBHalt' and: [aBlock selector = #deactivated]]]