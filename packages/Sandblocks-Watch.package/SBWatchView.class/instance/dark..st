as yet unclassified
dark: aBoolean

	self submorphs from: 1 to: 2 do: [:morph | morph color: (aBoolean ifTrue: [Color lightGray] ifFalse: [Color black])].
	
	dark := aBoolean.
	display dark: aBoolean