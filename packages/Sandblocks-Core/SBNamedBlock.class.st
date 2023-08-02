Class {
	#name : #SBNamedBlock,
	#superclass : #SBBlock,
	#instVars : [
		'name',
		'block'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBNamedBlock class >> block: aSBBlock named: aString [

	^ self new
		block: aSBBlock;
		name: aString
]

{ #category : #'as yet unclassified' }
SBNamedBlock >> block [

	^ block
]

{ #category : #'as yet unclassified' }
SBNamedBlock >> block: aSBBlock [

	block := aSBBlock
]

{ #category : #'as yet unclassified' }
SBNamedBlock >> initialize [

	super initialize.
	
	self name: 'A Block'.
	self block: (SBLabel new contents: 'Some Content').
]

{ #category : #'as yet unclassified' }
SBNamedBlock >> name [

	^ name
]

{ #category : #'as yet unclassified' }
SBNamedBlock >> name: aString [

	name := aString
]
