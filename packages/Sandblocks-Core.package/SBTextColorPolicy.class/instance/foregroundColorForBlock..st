as yet unclassified
foregroundColorForBlock: aBlock

	aBlock isMessageSend ifTrue: [^ Color blue].
	aBlock isMessagePart ifTrue: [^ Color blue].
	aBlock isPragma ifTrue: [^ Color green].
	aBlock isLiteralBlock ifTrue: [^ Color red muchDarker].
	^ Color black