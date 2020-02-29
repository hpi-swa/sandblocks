callbacks
filterMorph

	| pos morphs morph |
	pos := Point fromUser.
	morphs := (self world morphsAt: pos) select: [:m | expressions keys anySatisfy: [:exp | exp subject = m]].
	morphs ifEmpty: [^ UIManager default inform: 'Morph does not have an active expression'].
	morph := morphs size > 1 ifTrue: [morphs at: ((UIManager default chooseFrom: morphs) ifNil: [^ self])] ifFalse: [morphs first].
	self selectExpression: (expressions keys detect: [:expression | expression subject = morph])