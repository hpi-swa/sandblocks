"
A SBSandboxPasteUpMorph guards the drawing of its submorphs and triggers an event if any errors were raised while drawing.
"
Class {
	#name : #SBSandboxPasteUpMorph,
	#superclass : #PasteUpMorph,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #painting }
SBSandboxPasteUpMorph >> drawSubmorphsOn: aCanvas [

	[super drawSubmorphsOn: aCanvas] on: Error do: [:error | self triggerEvent: #reportError with: error]
]

{ #category : #painting }
SBSandboxPasteUpMorph >> initialize [

	super initialize.
	
	self enableDrop: false
]

{ #category : #'as yet unclassified' }
SBSandboxPasteUpMorph >> model [

	^ model
]

{ #category : #'as yet unclassified' }
SBSandboxPasteUpMorph >> wantsDroppedMorph: aMorph event: evt [

	^ false
]
