Extension { #name : #NewColorPickerMorph }

{ #category : #'*Sandblocks-Core' }
NewColorPickerMorph >> delete [

	super delete.
	
	self triggerEvent: #closed
]
