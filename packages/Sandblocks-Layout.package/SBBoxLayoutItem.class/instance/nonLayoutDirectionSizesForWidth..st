layout
nonLayoutDirectionSizesForWidth: aNumber

	| preferred |
	preferred := self widget preferredSizeForWidth: (vertical ifTrue: [aNumber] ifFalse: [aNumber max: self finalSize]).
	
	^ PHSizeRequest
		min: (vertical ifTrue: [preferred minSize x] ifFalse: [preferred minSize y])
		natural: (vertical ifTrue: [preferred naturalSize x] ifFalse: [preferred naturalSize y])