Class {
	#name : #SBASTNode,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBASTNode >> object [

	^ (Compiler new compileNoPattern: self sourceString in: self containingArtefact relatedClass notifying: nil ifFail: [])
		body statements first expr
]
