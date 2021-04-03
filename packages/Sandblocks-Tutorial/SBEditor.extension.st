Extension { #name : #SBEditor }

{ #category : #'*Sandblocks-Tutorial' }
SBEditor class >> openExample [
	" self openExample "

	| editor |
	editor := self new openWelcome.
	
	editor openInWindow.
	^ editor
]
