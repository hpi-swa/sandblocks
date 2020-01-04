as yet unclassified
= aCodeContext

	^ self methodClass = aCodeContext methodClass and: [self selector = aCodeContext selector and: [self pc = aCodeContext pc]]