Class {
	#name : #SBTSInlineBlockTest,
	#superclass : #TestCase,
	#category : #'Sandblocks-TreeSitter-Tests'
}

{ #category : #'as yet unclassified' }
SBTSInlineBlockTest >> testChoiceContinueMatching [

	| block |
	block := SBInlineBlockGroup new elements: {
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: 'a'. SBInlineBlockLabel new label: 'ab'}.
		SBInlineBlockLabel new label: '"'}.
	self assert: (block buildFor: '"ab"' matchFullToken: false) notEmpty
]

{ #category : #'as yet unclassified' }
SBTSInlineBlockTest >> testMatchChoice [

	| block result |
	block := SBInlineBlockChoice new alternatives: {SBInlineBlockLabel new label: 'a'. SBInlineBlockLabel new label: 'ab'. SBInlineBlockLabel new label: 'c'}.
	result := block buildFor: 'a' readStream matchFullToken: false.
	self assert: 4 equals: result size.
	self assert: 'a' equals: result firstSubmorph contents.
	self assert: 'ab' equals: result submorphs second contents
]

{ #category : #'as yet unclassified' }
SBTSInlineBlockTest >> testMatchGroup [

	| block result |
	block := SBInlineBlockGroup new elements: {
		SBInlineBlockLabel new label: '"'.
		SBInlineBlockText new regexString: '[A-Z]*'.
		SBInlineBlockLabel new label: '"'}.
	result := block buildFor: '"A' readStream matchFullToken: false options: nil.
	self assert: 3 equals: result submorphCount
]

{ #category : #'as yet unclassified' }
SBTSInlineBlockTest >> testMatchLabel [

	| block result |
	block := SBInlineBlockText new regexString: '\"[A-Z]*'.
	result := block buildFor: '"AB123' readStream matchFullToken: false options: nil.
	self assert: '"AB' equals: result contents
]
