as yet unclassified
useSuggestionOn: aBlock

	self completionAction ifNotNil: [self completionAction value: aBlock] ifNil: [aBlock useSuggestion: self selector]