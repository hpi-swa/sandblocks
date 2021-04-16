Class {
	#name : #SBStNewPragma,
	#superclass : #SBStNewMessageSend,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStNewPragma >> insetWithoutReceiver [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNewPragma >> isPragma [

	^ true
]

{ #category : #'as yet unclassified' }
SBStNewPragma >> selector: aSymbol arguments: aCollection [

	self receiver: nil selector: aSymbol arguments: aCollection
]

{ #category : #'as yet unclassified' }
SBStNewPragma >> symbols [

	^ self colorPolicy symbolsForPragma: self
]

{ #category : #'as yet unclassified' }
SBStNewPragma >> valid [

	^ (self parentSandblock isBlockBody and: [self parentSandblock isMethodBody]) and: [
		self selector notEmpty and: [ | lastIndex |
			lastIndex := self parentSandblock statements indexOf: self.
			((self parentSandblock statements viewFrom: 1 to: lastIndex) allSatisfy: #isPragma) and: [self arguments allSatisfy: #isLiteralBlock]]]
]
