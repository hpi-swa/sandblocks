"
An SBJsMMBrowserWrapper is SBBlock used to wrap the MMBrowserMorph so that the MMBrowserMorph can take keyboard input from within sandblocks. For this to work the selection of the active Block of Sandblocks must be this instance and the highlighting must be only the lower border of the instance. To get there select this block or an outer block of it and navigate inwards via shift + down arrow until reached. It is also possible to directly reach the selection via careful clicking.

Instance Variables
	- None
	

Interesting points where to start:
- This class only wraps a MMBrowserMorph so that keyboad input can be forwarded to the browser morph. Nothing really interesting can be found here.
"
Class {
	#name : #SBJsMMBrowserWrapper,
	#superclass : #SBInlineBlockReplace,
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #input }
SBJsMMBrowserWrapper >> absorbsInput: anEvent [

	^ true
]

{ #category : #input }
SBJsMMBrowserWrapper >> currentTextMorph [

	^ self submorphs size > 0 ifTrue: [self firstSubmorph] ifFalse: [nil]
]

{ #category : #input }
SBJsMMBrowserWrapper >> drawnColor [

	^ Color veryDarkGray
]

{ #category : #input }
SBJsMMBrowserWrapper >> initialize [

	super initialize.
	self factory: SBJavascript instance
]
