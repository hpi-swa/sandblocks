Class {
	#name : #SBTemporaries,
	#superclass : #SBBlockRow,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBTemporaries >> drawOn: aCanvas [

	self submorphCount > 0 ifTrue: [ | inset fixWidth font color |
		color := self parentSandblock foregroundColor.
		inset := self layoutInset // 2.
		font := self fontToUse.
		fixWidth := ((font widthOf: $|) // 2) rounded.
		aCanvas drawString: '|' at: (self position + inset) - (fixWidth @ 0) font: nil color: color.
		aCanvas
			drawString: '|'
			at: (self position + (self width @ 0)) + ((inset x negated - fixWidth) @ inset y)
			font: nil
			color: color]
]

{ #category : #'as yet unclassified' }
SBTemporaries >> initialize [

	super initialize.
	
	self layoutInset: (4 @ 2) withScalingFactor
]

{ #category : #'as yet unclassified' }
SBTemporaries >> isTemporaries [

	^ true
]

{ #category : #'as yet unclassified' }
SBTemporaries >> visible [

	^ self hasSubmorphs
]

{ #category : #'as yet unclassified' }
SBTemporaries >> writeSourceOn: aStream [

	self hasSubmorphs ifFalse: [^ self].
	
	aStream nextPutAll: '| '.
	self childSandblocksDo: [:m | m writeSourceOn: aStream. aStream space].
	aStream nextPutAll: '|'
]
