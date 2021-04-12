"
A SBPCMapper fills out program counter values for a given MethodNode.

Rationale: Usually, pc values are only filled out if you call #generate on a MethodNode. This, however, applies optimizations and restructures the AST. Thus, we can use this helper to fill out pc values in an unmodified AST.
"
Class {
	#name : #SBPCMapper,
	#superclass : #Object,
	#category : #'Sandblocks-Utils'
}

{ #category : #'sanity check' }
SBPCMapper class >> sanityCheck [
	" self sanityCheck "

	(Array streamContents: [:s |
		(PackageInfo named: 'Kernel') classes do: [:class |
			class methodsDo: [:m | s nextPut: m]]]) do: [:m | self sanityCheck: m] displayingProgress: 'Checking'
]

{ #category : #'sanity check' }
SBPCMapper class >> sanityCheck: aMethod [

	aMethod asSandblock
]

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

{ #category : #'as yet unclassified' }
SBPCMapper >> buildNodeMapFor: aString in: aClass [

	| nodeMap generatedMethodNode prettyMethodNode generatedNodes prettyNodes |
	prettyMethodNode := (PPParser new encoderClass: PPFormatEncoder)
		includeGenerated: true;
		parse: aString methodWithEmptyLineMarkers class: aClass.
	generatedMethodNode := Parser new parse: aString class: aClass.
	
	nodeMap := IdentityDictionary new.
	
	" remember a mapping between our unchanged pretty and generated node trees "
	prettyNodes := Array streamContents: [:stream |
		prettyMethodNode accept: (ParseNodeEnumerator ofBlock: [:node | (node isLiteralNode and: [node key = #ppEmptyLine]) ifFalse: [stream nextPut: node]])].
	generatedNodes := Array streamContents: [:stream |
		generatedMethodNode accept: (ParseNodeEnumerator ofBlock: [:node | stream nextPut: node])].
	
	prettyNodes size = generatedNodes size ifFalse: [^ prettyMethodNode].
	prettyNodes with: generatedNodes do: [:original :new | nodeMap at: original put: new].
	
	" now generate the method, annotating the generated tree "
	generatedMethodNode generate.
	
	" finally copy over the info from the generated to the pretty tree "
	prettyMethodNode accept: (ParseNodeEnumerator ofBlock: [:node |
		nodeMap at: node ifPresent: [:generatedNode |
			node pc: generatedNode pc.
			node isBlockNode ifTrue: [
				node closureCreationNode: generatedNode closureCreationNode]]]).
	
	^ prettyMethodNode
]
