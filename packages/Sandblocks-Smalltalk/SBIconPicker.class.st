Class {
	#name : #SBIconPicker,
	#superclass : #SBStSubstitution,
	#instVars : [
		'icon'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #testing }
SBIconPicker class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].
	^ aBlock satisfies: {
		#isMessageSend.
		[:b | b receiver satisfies: {#isBinding. [:r | r contents = 'SBIcon']}].
		[:b | b selector beginsWith: 'icon']
	}
]

{ #category : #'instance creation' }
SBIconPicker class >> newFor: aBlock [

	^ self new icon: aBlock selector
]

{ #category : #'as yet unclassified' }
SBIconPicker >> drawnColor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBIconPicker >> icon: aSymbol [

	icon := aSymbol asSymbol.
	self addMorphBack: (SBIcon perform: icon)
]

{ #category : #'as yet unclassified' }
SBIconPicker >> initialize [

	super initialize.
	self
		changeTableLayout;
		layoutInset: 4;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBIconPicker >> writeSourceOn: aStream [

	aStream nextPutAll: 'SBIcon '.
	aStream nextPutAll: icon
]
