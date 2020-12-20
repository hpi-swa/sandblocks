as yet unclassified
matches: aBlock

	(super matches: aBlock) ifFalse: [^ false].

	^ (aBlock selector = 'halt' and: [aBlock isInCascade not]) or: [aBlock receiver isName and: [aBlock receiver contents = 'SBHalt' and: [aBlock selector = #deactivated]]]