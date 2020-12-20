as yet unclassified
parentIsKeywordSend

	^ self parentSandblock ifNotNil: [:p | p isMessageSend and: [p isKeyword]] ifNil: [false]