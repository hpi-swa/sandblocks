Class {
	#name : #SBSelectionDecorator,
	#superclass : #SBBlockDecorator,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSelectionDecorator >> postDrawOn: aCanvas [

	| b color |
	b := self morph bounds expandBy: 2.
	color := (self morph parentSandblock ifNil: [self morph]) foregroundColor.
	
	self morph sandblockEditor mode = #input
		ifTrue: [
			aCanvas line: b bottomLeft to: b bottomRight width: self morph frameSize color: color]
		ifFalse: [
			aCanvas frameRectangle: b width: self morph frameSize color: color]
]
