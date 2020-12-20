as yet unclassified
contextAcceptedRepresentationAt: aNumber

	SBToggledCode
		comment: 'need insert vs replace semantics for this :('
		active: 0
		do: {
			[
				aNumber = self childSandblocks size ifTrue: [^ #isSmalltalkBlock]]
		}.
	^ aNumber odd ifTrue: [#isSmalltalkMessagePart] ifFalse: [#isSmalltalkExpression]