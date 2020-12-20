layout
takeWidth: aNumber

	| preferred |
	preferred := self widget preferredSizeForWidth: aNumber.
	
	self
		minSize: (vertical ifTrue: [preferred minSize y] ifFalse: [preferred minSize x]);
		naturalSize: (vertical ifTrue: [preferred naturalSize y] ifFalse: [preferred naturalSize x]);
		finalSize: (vertical ifTrue: [preferred minSize y] ifFalse: [preferred minSize x])