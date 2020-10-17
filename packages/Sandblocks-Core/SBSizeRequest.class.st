"
A PHSizeRequest stores the minimum and natural size of a widget.
"
Class {
	#name : #SBSizeRequest,
	#superclass : #Object,
	#instVars : [
		'minSize',
		'naturalSize'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #helpers }
SBSizeRequest class >> fixed: aPoint [

	^ self min: aPoint natural: aPoint
]

{ #category : #helpers }
SBSizeRequest class >> min: aPoint natural: anotherPoint [

	^ self new
		minSize: aPoint;
		naturalSize: anotherPoint;
		yourself
]

{ #category : #arithmetics }
SBSizeRequest >> + aPoint [

	aPoint isPoint ifTrue: [
		^ self copy
			minSize: (self minSize + aPoint) asPoint;
			naturalSize: (self naturalSize + aPoint) asPoint].
	
	^ aPoint adaptToSizeRequest: self andSend: #+
]

{ #category : #comparing }
SBSizeRequest >> = aSizeRequest [

	^ self minSize = aSizeRequest minSize and: [self naturalSize = aSizeRequest naturalSize]
]

{ #category : #accessing }
SBSizeRequest >> adjustFor: aMorph [
	" makes sure minSize and maxSize are adhered to "
	| min natural |
	self flag: #todo. " need maxSize? "
	min := self minSize max: aMorph minimumExtent.
	
	natural := self naturalSize.
	"naturalX := maxSize x < 0 ifTrue: [natural x] ifFalse: [natural x min: maxSize x].
	naturalY := maxSize y < 0 ifTrue: [natural y] ifFalse: [natural y min: maxSize y]."
	
	^ self
		minSize: min;
		naturalSize: (natural max: min);
		yourself
]

{ #category : #comparing }
SBSizeRequest >> hash [
	" copied from Rectangle>>hash "

	^ minSize hash bitXor: naturalSize hash
]

{ #category : #accessing }
SBSizeRequest >> minSize [

	^ minSize
]

{ #category : #accessing }
SBSizeRequest >> minSize: aNumber [

	minSize := aNumber
]

{ #category : #accessing }
SBSizeRequest >> naturalSize [

	^ naturalSize
]

{ #category : #accessing }
SBSizeRequest >> naturalSize: aNumber [

	naturalSize := aNumber
]

{ #category : #accessing }
SBSizeRequest >> printOn: aStream [

	aStream
		nextPutAll: self className;
		nextPut: $(;
		nextPutAll: 'min: ';
		print: self minSize;
		nextPutAll: ', nat: ';
		print: self naturalSize;
		nextPut: $)
]
