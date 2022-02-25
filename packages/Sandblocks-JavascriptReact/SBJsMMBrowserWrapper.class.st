"
A SBJsMMBrowserWrapper is SBBlock used to wrap the MMBrowserMorph so that the MMBrowserMorph can take keyboard input from within sandblocks. For this to work the selection of the active Block of Sandblocks must be this instance and the highlightin must be only the lower border of the instance. To get there select this block or a outer block of it and navigate inwards via shift + down arrow until reached.

Instance Variables
	- None
"
Class {
	#name : #SBJsMMBrowserWrapper,
	#superclass : #SBBlock,
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #input }
SBJsMMBrowserWrapper >> absorbsInput: anEvent [
	"self firstSubmorph keyStroke: anEvent."

	^ true
]

{ #category : #input }
SBJsMMBrowserWrapper >> currentTextMorph [

	^ self submorphs size > 0 ifTrue: [self firstSubmorph] ifFalse:[nil]
]

{ #category : #input }
SBJsMMBrowserWrapper >> drawnColor [

	^ Color veryDarkGray
]
