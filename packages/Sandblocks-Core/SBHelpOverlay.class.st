Class {
	#name : #SBHelpOverlay,
	#superclass : #Morph,
	#instVars : [
		'target'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBHelpOverlay class >> on: aBlock [

	^ self new target: aBlock
]

{ #category : #'as yet unclassified' }
SBHelpOverlay >> initialize [

	super initialize.
	self color: Color transparent
]

{ #category : #'as yet unclassified' }
SBHelpOverlay >> rejectsEvent: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBHelpOverlay >> target: aBlock [

	target := aBlock.
	self openInWorld.
	self position: 0 @ 0.
	self addMorphBack: ((SBHelpShortcut new shortcuts: {({$o asSandblockShortcut. 'Statement below'}). ({$p asSandblockShortcut. 'Paste below'})}) below: aBlock).
	self addMorphBack: ((SBHelpShortcut new shortcuts: {({$O asSandblockShortcut. 'Statement above'}). ({$P asSandblockShortcut. 'Paste above'})}) above: aBlock)
]
