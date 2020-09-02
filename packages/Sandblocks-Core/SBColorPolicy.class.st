Class {
	#name : #SBColorPolicy,
	#superclass : #Object,
	#classVars : [
		'BoldMessageSends',
		'UsePango'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBColorPolicy class >> boldMessageSends [

	^ BoldMessageSends ifNil: [true]
]

{ #category : #'as yet unclassified' }
SBColorPolicy class >> usePango [

	^ UsePango ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> borderColorForBlock: aBlock [

	^ (self foregroundColorForBlock: aBlock) alpha: 0.2
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> borderWidthForBlock: aBlock [

	^ aBlock isMethod ifTrue: [0] ifFalse: [1]
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> centerAlignSymbols [

	^ true
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> colorForBlock: aBlock [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> foregroundColorForBlock: aBlock [

	| color |
	color := aBlock drawnColor.
	(color alpha = 0 and: [aBlock parentSandblock notNil]) ifTrue: [color := aBlock parentSandblock drawnColor].
	^ self foregroundColorForColor: color
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> foregroundColorForColor: aColor [

	^ aColor luminance > 0.6 ifTrue: [Color black] ifFalse: [Color white]
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> layoutInset [

	^ 2
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> layoutInsetFor: aBlock [

	^ 2
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> lineGap [

	^ 0
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> messageCellGap [

	^ 4
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> selectionBorderWidth [

	^ 3
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> selectionColorForBlock: aBlock [

	^ aBlock foregroundColor
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForArray: aBlock [

	^ #('{} ' nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForAssignment: aBlock [

	^ #(nil nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForAssignmentLabel: aBlock [

	^ #(nil nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForBinding: aBlock [

	^ #(nil nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForBlock: aBlock [

	^ #(' [] ' nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForBlockDeclaration: aBlock [

	^ #(':' nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForBoolean: aBlock [

	^ #(nil nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForByteArray: aBlock [

	^ #('#[] ' nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForCharacter: aBlock [

	^ #('$' nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForComment: aBlock [

	^ #('" ' ' "')
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForInstanceVariableDeclaration: aBlock [

	^ #(nil nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForKeywordBinding: aBlock [

	^ #(nil nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForLiteralArray: aBlock [

	^ #('#() ' nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForLocalVariableDeclaration: aBlock [

	^ #(nil nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForMessagePart: aBlock [

	^ aBlock hasColon ifTrue: [#(nil ':')] ifFalse: [#(nil nil)]
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForMessageSend: aBlock [

	^ #(nil nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForMethodArgumentDeclaration: aBlock [

	^ #(nil nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForNumber: aBlock [

	^ #(nil nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForPoolVariableDeclaration: aBlock [

	^ #(nil nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForPragma: aBlock [

	^ #('<> ' nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForRegex: aBlock [

	^ #('r' nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForReturn: aBlock [

	^ #('^ ' nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForString: aBlock [

	^ #('''' '''')
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForSymbol: aBlock [

	^ #('#' nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForTemporaryVariableDeclaration: aBlock [

	^ #(nil nil)
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsForUnknown: aBlock [

	^ #(nil nil)
]
