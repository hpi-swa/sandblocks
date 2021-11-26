Class {
	#name : #SBInlineBrowser,
	#superclass : #SBInlineBlockReplace,
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #'as yet unclassified' }
SBInlineBrowser class >> newAtUrl: aString [

	self new addMorphBack: (MMBrowserMorph openOn: aString)
]
