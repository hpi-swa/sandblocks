as yet unclassified
buildNodeMapFor: aMethodNode do: aBlock

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