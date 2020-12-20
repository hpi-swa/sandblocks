layout
inVerticalLayout: aBoolean

	vertical := aBoolean.
	
	self expanding:
		((self morph: self widget wantsExpandIn: aBoolean) at: (aBoolean ifTrue: [2] ifFalse: [1]))
		"((self widget wantsExpandIn: aBoolean) at: (aBoolean ifTrue: [2] ifFalse: [1]))"