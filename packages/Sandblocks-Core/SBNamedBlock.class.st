Class {
	#name : #SBNamedBlock,
	#superclass : #SBBlock,
	#instVars : [
		'name',
		'block'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'instance creation' }
SBNamedBlock class >> block: aSBBlock named: aString [

	^ self new
		block: aSBBlock;
		name: aString
]

{ #category : #accessing }
SBNamedBlock >> block [

	^ block
]

{ #category : #accessing }
SBNamedBlock >> block: aSBBlock [

	block := aSBBlock
]

{ #category : #initialization }
SBNamedBlock >> initialize [

	super initialize.
	
	self name: 'A Block'.
	self block: (SBLabel new contents: 'Some Content').
]

{ #category : #accessing }
SBNamedBlock >> name [

	^ name
]

{ #category : #accessing }
SBNamedBlock >> name: aString [

	name := aString
]
