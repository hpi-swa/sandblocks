Extension { #name : #SBEditor }

{ #category : #'*Sandblocks-Tutorial' }
SBEditor class >> openExample [
	" self openExample "

	| editor |
	editor := self new.
	
	editor openMorphInView: SBScmModule example.
	editor openMorphInView: SBJsModule example.
	editor openMorphInView: (SBStPlayground example name: 'Smalltalk Workspace').
	SBTutorialStep resumeIn: editor.
	
	editor openInWindow.
	^ editor
]
