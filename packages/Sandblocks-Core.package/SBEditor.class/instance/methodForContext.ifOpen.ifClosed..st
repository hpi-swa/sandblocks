actions
methodForContext: aContext ifOpen: aBlock ifClosed: anotherBlock

	^ self methods
		detect: [:m | m methodClass = aContext methodClass and: [m selector = aContext selector]]
		ifFound: aBlock
		ifNone: anotherBlock