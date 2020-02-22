actions
selectToplevelTowards: aSideSymbol

	| opposite |
	opposite := aSideSymbol caseOf: {[#left] -> [#right]. [#right] -> [#left]. [#top] -> [#bottom]. [#bottom] -> [#top]}.
	
	self select: (self selection containingArtefact closestAdjacentFrom: (aSideSymbol, 'Center') asSymbol to: (opposite, 'Center') asSymbol)