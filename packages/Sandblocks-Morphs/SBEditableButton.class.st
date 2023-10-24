Class {
	#name : #SBEditableButton,
	#superclass : #SBButton,
	#category : #'Sandblocks-Morphs'
}

{ #category : #initialization }
SBEditableButton >> textMorphFor: aString [

	^ self widgetClass new
		contents: aString;
		emphasis: TextEmphasis bold emphasisCode;
		bordered: false;
		when: #clicked
		send: #doButtonAction  
		to: self;
		when: #doubleClicked
		send: #triggerEvent:
		to: self
		with: #doubleClicked;
		when: #contentsChanged
		send: #triggerEvent:
		to: self
		with: #contentsChanged;
		when: #contentsChanged
		send: #hResizing:
		to: self
		with: self hResizing
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
