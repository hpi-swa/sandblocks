Class {
	#name : #SBPCMapper,
	#superclass : #Object,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBPCMapper >> applyMappingFor: aMethodNode [

	self
		buildNodeMapFor: aMethodNode
		do: [:nodeMap :generated |
			aMethodNode accept: (ParseNodeEnumerator ofBlock: [:node | | generatedNode |
				generatedNode := nodeMap at: node.
				node pc: generatedNode pc.
				node isBlockNode ifTrue: [
					node closureCreationNode: generatedNode closureCreationNode]])].
	^ aMethodNode
]

{ #category : #'as yet unclassified' }
SBPCMapper >> buildNodeMapFor: aMethodNode do: aBlock [

	| nodeMap generated originalNodes newNodes |
	nodeMap := IdentityDictionary new.
	generated := aMethodNode veryDeepCopy.
	
	originalNodes := Array streamContents: [:stream |
		aMethodNode accept: (ParseNodeEnumerator ofBlock: [:node | stream nextPut: node])].
	newNodes := Array streamContents: [:stream |
		generated accept: (ParseNodeEnumerator ofBlock: [:node | stream nextPut: node])].
	originalNodes with: newNodes do: [:original :new | nodeMap at: original put: new].
	
	^ aBlock value: nodeMap value: (generated
		generate;
		yourself)
]
