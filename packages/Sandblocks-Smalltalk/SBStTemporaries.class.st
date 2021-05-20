Class {
	#name : #SBStTemporaries,
	#superclass : #SBBlockRow,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStTemporaries >> drawOn: aCanvas [

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
SBStTemporaries >> initialize [

	super initialize.
	

]

{ #category : #'as yet unclassified' }
SBStTemporaries >> isTemporaries [

	^ true
]

{ #category : #'as yet unclassified' }
SBStTemporaries >> layoutInset [

	^ self hasSubmorphs ifTrue: [4 @ 2] ifFalse: [0]
]

{ #category : #'as yet unclassified' }
SBStTemporaries >> writeSourceOn: aStream [

	self hasSubmorphs ifFalse: [^ self].
	
	aStream nextPutAll: '| '.
	self childSandblocksDo: [:m | m writeSourceOn: aStream. aStream space].
	aStream nextPutAll: '|'
]
