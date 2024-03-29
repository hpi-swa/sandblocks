Extension { #name : #SBStMessageSend }

{ #category : #'*Sandblocks-Babylonian' }
SBStMessageSend >> suggestedAlternationName [

	^ self isAssignment
		ifTrue: [self receiver suggestedAlternationName]
		ifFalse: [
			SBVariant
				named: 'format: to ''{1} to {2}'''
				associations: {
					'with sender' -> ['{1} to {2}' format: {self selector. self receiver suggestedAlternationName}].
					'w/o sender' -> ['{1}' format: {self selector}]}
				activeIndex: 2
				id: '1949332c-4768-ff4a-98ba-0356e4a3f2fa'
				isActive: false]
]
