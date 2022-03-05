Class {
	#name : #SBColorPolicy,
	#superclass : #Object,
	#instVars : [
		'enlarge'
	],
	#classVars : [
		'BoldMessageSends',
		'UsePango'
	],
	#category : #'Sandblocks-Core'
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
SBColorPolicy >> borderColorForButton: aColor [

	^ Color veryLightGray
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> borderWidthForBlock: aBlock [

	^ aBlock isMethod ifTrue: [0] ifFalse: [1]
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> brighten: aColor by: aNumber [

	| lab |
	lab := self colorToLAB: aColor.
	^ self labToColor: (lab collect: [:c | c * 1.1])
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
SBColorPolicy >> colorForButton: aButton [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> colorForEditor: anEditor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> colorToLAB: aColor [

	| red green adjustVal blue x y z adjustXYZ l a b |
	adjustVal := [:val | (val > 0.04045 ifTrue: [val + 0.055 / 1.055 raisedTo: 2.4] ifFalse: [val / 12.92]) * 100].
	red := adjustVal value: aColor red.
	green := adjustVal value: aColor green.
	blue := adjustVal value: aColor blue.
	
	adjustXYZ := [:val | val > 0.008856 ifTrue: [val raisedTo: 1.0 / 3.0] ifFalse: [7.787 * val + (16.0 / 116.0)]].
	x := adjustXYZ value: red * 0.4124 + (green * 0.3576 + (blue * 0.1805)) / 95.047.
	y := adjustXYZ value: red * 0.2126 + (green * 0.7152 + (blue * 0.0722)) / 100.0.
	z := adjustXYZ value: red * 0.0193 + (green * 0.1192 + (blue * 0.9505)) / 108.883.
	
	l := 116 * y - 16.
	a := 500 * (x - y).
	b := 200 * (y - z).
	
	^ {l. a. b}
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> cornerRadius [

	^ 0
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> drawnColorOfOpaque: aBlock [

	| block |
	block := aBlock.
	[block drawnColor alpha = 0 and: [block parentSandblock notNil]] whileTrue: [block := block parentSandblock].
	^ block drawnColor
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> dropMarkerColorFor: aMorph [

	^ Color r: 0.942 g: 0.968 b: 0.627
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> enlarge [

	^ enlarge ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> enlarge: aBoolean [

	enlarge := aBoolean
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> foregroundColorForBlock: aBlock [

	| color |
	color := self drawnColorOfOpaque: aBlock.
	^ self foregroundColorForColor: color
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> foregroundColorForButton: aButton [

	^ Color black
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> foregroundColorForColor: aColor [

	^ aColor luminance > 0.57 ifTrue: [Color black] ifFalse: [Color white]
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> highlightColor [ 

	^ Color yellow
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> labToColor: aCollection [

	| y x z adjustVal r g b adjustRGB |
	adjustVal := [:val |
		(val raisedTo: 3) > 0.008856
			ifTrue: [val raisedTo: 3]
			ifFalse: [val - (16.0 / 116.0) / 7.787]].
	
	y := aCollection first + 16.0 / 116.0.
	x := (adjustVal value: aCollection second / 500 + y) * 95.047 / 100.0.
	z := (adjustVal value: y - (aCollection third / 200)) * 108.883 / 100.0.
	y := adjustVal value: y.
	
	adjustRGB := [:val |
		val > 0.0031308
			ifTrue: [1.055 * (val raisedTo: 1.0 / 2.4) - 0.055]
			ifFalse: [12.92 * val]].
	
	r := adjustRGB value: x * 3.2406 + (y * -1.5372 + (z * -0.4986)).
	g := adjustRGB value: x * -0.9689 + (y * 1.8758 + (z * 0.0415)).
	b := adjustRGB value: x * 0.0557 + (y * -0.204 + (z * 1.057)).
	
	^ Color r: r g: g b: b
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

	^ (aBlock parentSandblock ifNil: [aBlock]) foregroundColor
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
SBColorPolicy >> symbolsForClassVariableDeclaration: aBlock [

	^ #(nil nil)
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

	aBlock isAssignment ifTrue: [^ #(nil '=')].
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

{ #category : #'as yet unclassified' }
SBColorPolicy >> symbolsOpacity [

	^ 0.7
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> toggleEnlarge [

	self enlarge: self enlarge not
]

{ #category : #'as yet unclassified' }
SBColorPolicy >> toolColorFor: aBlock [

	^ Color veryDarkGray
]
