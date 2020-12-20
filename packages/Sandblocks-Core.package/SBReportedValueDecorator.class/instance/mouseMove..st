as yet unclassified
mouseMove: anEvent

	((self morph morphsAt: anEvent position) allSatisfy: [:m |
		m = self morph or: [
			m isSandblock not or: [
				SBToggledCode comment: 'Not nice to encode this here, find a good property' active: 1 do: {[m isMessagePart]}]]]) ifTrue: [self showLabel] ifFalse: [self hideLabel]