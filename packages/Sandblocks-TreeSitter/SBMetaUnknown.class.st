Class {
	#name : #SBMetaUnknown,
	#superclass : #SBUnknown,
	#instVars : [
		'factory',
		'slot',
		'type'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaUnknown >> contents: aString [

	self currentTextMorph contents: aString
]

{ #category : #'as yet unclassified' }
SBMetaUnknown >> factory: aFactory [

	factory := aFactory
]

{ #category : #'as yet unclassified' }
SBMetaUnknown >> isMetaBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBMetaUnknown >> keyStroke: anEvent [

	self currentTextMorph keyStroke: anEvent.
	
	factory unambiguousRule: slot for: self contents do: [:new | | editor |
		editor := self sandblockEditor.
		new startInputCommand
			ifNil: [
				editor
					do: (SBReplaceCommand new
						target: self;
						replacer: new);
					endInput.
				new startNextInput]
			ifNotNil: [
				self replaceBy: new.
				editor replaceInput: new]]
]

{ #category : #'as yet unclassified' }
SBMetaUnknown >> objectInterface [

	^ self shouldNotImplement
]

{ #category : #'as yet unclassified' }
SBMetaUnknown >> parentSlot [

	^ slot
]

{ #category : #'as yet unclassified' }
SBMetaUnknown >> printOn: aStream [

	aStream
		nextPutAll: 'unknown ';
		nextPutAll: (self slot name ifNil: ['<>'])
]

{ #category : #'as yet unclassified' }
SBMetaUnknown >> slot [

	^ slot
]

{ #category : #'as yet unclassified' }
SBMetaUnknown >> slot: aSlot [

	slot := aSlot
]
