Class {
	#name : #SBEditableButton,
	#superclass : #SBButton,
	#category : #'Sandblocks-Morphs'
}

{ #category : #'as yet unclassified' }
SBEditableButton >> widget: aMorph shortcut: aShortcut do: aBlock [

	super widget: aMorph shortcut: aShortcut do: aBlock.
	
	self widgetMorph 
			when: #contentsChanged
			send: #triggerEvent:
			to: self
			with: #contentsChanged
]

{ #category : #initialization }
SBEditableButton >> widgetClass [

	^ SBTextBubble  
]

{ #category : #initialization }
SBEditableButton >> widgetMorph [

	^ self submorphs detect: [:m | m isKindOf: self widgetClass] 
		ifFound:[:m | m textMorph] 
		ifNone: [nil]
]
