accessing
componentName

	| identifier |
	self access children size <= 0 ifTrue: [^ nil].
	identifier := self access children first.
	
	^ identifier children size > 0
		ifTrue: [identifier children first contents]
		ifFalse: [identifier contents]