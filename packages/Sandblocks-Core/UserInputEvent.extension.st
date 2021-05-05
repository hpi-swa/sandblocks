Extension { #name : #UserInputEvent }

{ #category : #'*Sandblocks-Core' }
UserInputEvent >> optionKeyPressed [
	"Answer if the option key on the keyboard was being held down when this event occurred."

	^ self buttons anyMask: (2r0100 "opt" bitShift: 3)
]
