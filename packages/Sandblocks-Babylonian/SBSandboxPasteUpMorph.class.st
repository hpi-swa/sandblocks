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
