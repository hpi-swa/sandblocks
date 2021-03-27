Extension { #name : #SBEditor }

{ #category : #'*Sandblocks-Tutorial' }
SBEditor class >> openExample [
	" self openExample "

	| editor |
	editor := self new.
	
	editor openMorphInView: SBWelcome new.
	
	editor openInWindow.
	^ editor
]
