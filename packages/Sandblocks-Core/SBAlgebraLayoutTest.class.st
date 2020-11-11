Class {
	#name : #SBAlgebraLayoutTest,
	#superclass : #TestCase,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testBasic [

	| doc a b |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand morph data: (a := Morph new).
		SBAlgebraCommand morph data: (b := Morph new)}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 300.
	
	self assert: 0 @ 0 equals: a position.
	self assert: a width @ 0 equals: b position
]

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testBasicWrap [

	| doc a b |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand morph data: (a := Morph new).
		SBAlgebraCommand hardLine.
		SBAlgebraCommand morph data: (b := Morph new)}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 300.
	
	self assert: 0 @ 0 equals: a position.
	self assert: 0 @ a height equals: b position
]

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testContainerBounds [

	| doc a b container |
	doc := SBAlgebraCommand container
		morph: (container := Morph new hResizing: #shrinkWrap; vResizing: #shrinkWrap);
		data: {
			SBAlgebraCommand morph data: (a := Morph new extent: 80 @ 40).
			SBAlgebraCommand hardLine.
			SBAlgebraCommand morph data: (b := Morph new)}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 300.
	self assert: 0 @ 0 equals: a position.
	self assert: 0 @ 40 equals: b position.
	self assert: 80 @ 80 equals: container extent
]

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testContainerInset [

	| doc a b container |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand container
			morph: (container := Morph new layoutInset: 10; hResizing: #shrinkWrap; vResizing: #shrinkWrap);
			data: {SBAlgebraCommand morph data: (a := Morph new)}.
		SBAlgebraCommand hardLine.
		SBAlgebraCommand morph data: (b := Morph new)}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 300.
	self assert: 70 @ 60 equals: container extent.
	self assert: 10 @ 10 equals: a position.
	self assert: 0 @ 60 equals: b position
]

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testContainerInsetMultipleChildren [

	| doc a b container |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand container
			morph: (container := Morph new layoutInset: 30; hResizing: #shrinkWrap; vResizing: #shrinkWrap);
			data: {
				SBAlgebraCommand morph data: (a := Morph new).
				SBAlgebraCommand hardLine.
				SBAlgebraCommand morph data: (b := Morph new)}}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 300.
	self assert: 30 @ 30 equals: a position.
	self assert: 30 @ 70 equals: b position.
	self assert: 110 @ 140 equals: container extent
]

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testContainerLeftInset [

	| doc a b container |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand container
			morph: (container := Morph new layoutInset: (SBEdgeInsets left: 10); hResizing: #shrinkWrap; vResizing: #shrinkWrap);
			data: {SBAlgebraCommand morph data: (a := Morph new)}.
		SBAlgebraCommand hardLine.
		SBAlgebraCommand morph data: (b := Morph new)}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 300.
	self assert: 60 @ 40 equals: container extent.
	self assert: 10 @ 0 equals: a position.
	self assert: 0 @ 40 equals: b position
]

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testContainerWithLongerFirstChildAndInset [

	| doc container |
	doc := SBAlgebraCommand container
		morph: (container := Morph new layoutInset: 10; hResizing: #shrinkWrap; vResizing: #shrinkWrap);
		data: {
			SBAlgebraCommand morph data: (Morph new width: 80).
			SBAlgebraCommand hardLine.
			SBAlgebraCommand morph data: (Morph new width: 40)
		}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 500.
	self assert: 100 equals: container width
]

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testDoNotContinueOverllappingContainer [

	| doc a b c |
	doc :=  SBAlgebraCommand container
		morph: Morph new;
		data: {
			SBAlgebraCommand container
				morph: Morph new;
				data: {
					SBAlgebraCommand morph data: (a := Morph new extent: 200 @ 40).
					SBAlgebraCommand group data: {
						SBAlgebraCommand softLineOrGap data: false.
						SBAlgebraCommand container morph: Morph new; data: {SBAlgebraCommand morph data: (b := Morph new)}}}.
			SBAlgebraCommand group data: {
				SBAlgebraCommand softLineOrGap data: false.
				SBAlgebraCommand container
					morph: Morph new;
					data: {SBAlgebraCommand morph data: (c := Morph new)}}}.
	
	SBAlgebraLayout new layoutDocument: doc limit: a width + 30.
	self assert: 0 @ 0 equals: a position.
	self assert: 0 @ a height equals: b position.
	self assert: 0 @ (a height + b height) equals: c position
]

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testIndent [

	| doc a b |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand morph data: (a := Morph new).
		SBAlgebraCommand indent data: {
			SBAlgebraCommand softLine.
			SBAlgebraCommand morph data: (b := Morph new)}}.
	
	SBAlgebraLayout new layoutDocument: doc limit: a width + 21.
	self assert: 0 @ 0 equals: a position.
	self assert: 20 @ a height equals: b position
]

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testIndentDifferentOrigin [

	| doc a b |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand morph data: (a := Morph new).
		SBAlgebraCommand indent data: {
			SBAlgebraCommand softLine.
			SBAlgebraCommand morph data: (b := Morph new)}}.
	
	SBAlgebraLayout new layoutDocument: doc at: ((SBAlgebraState new offset: 30 @ 20) startX: 30) limit: a width + 21 wrap: false.
	self assert: 30 @ 20 equals: a position.
	self assert: (30 @ 20) + (20 @ a height) equals: b position
]

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testLineOrGap [

	| doc a b |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand morph data: (a := Morph new).
		SBAlgebraCommand softLineOrGap.
		SBAlgebraCommand morph data: (b := Morph new)}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 300.
	self assert: 0 @ 0 equals: a position.
	self assert: a width + SBAlgebraLayout gap @ 0 equals: b position.
	
	SBAlgebraLayout new layoutDocument: doc limit: a width + 1.
	self assert: 0 @ 0 equals: a position.
	self assert: 0 @ a height equals: b position
]

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testMorphInContainer [

	| doc a container innerContainer |
	doc := SBAlgebraCommand container
		morph: (container := Morph new position: 100 @ 100; layoutInset: 10; hResizing: #shrinkWrap; vResizing: #shrinkWrap; yourself);
		data: {
			SBAlgebraCommand container
				morph: (Morph new hResizing: #shrinkWrap; vResizing: #shrinkWrap);
				data: {SBAlgebraCommand morph data: (Morph new extent: 30 @ 30)}.
			SBAlgebraCommand hardLine.
			SBAlgebraCommand container
				morph: (innerContainer := Morph new layoutInset: 10; hResizing: #shrinkWrap; vResizing: #shrinkWrap);
				data: {SBAlgebraCommand morph data: (a := Morph new extent: 50 @ 50)}}.
	
	SBAlgebraLayout new
		layoutDocument: doc
		at: ((SBAlgebraState new offset: container position) startX: container left)
		limit: 300
		wrap: false.
	
	self assert: 90 @ 120 equals: container extent.
	self assert: 100 @ 100 equals: container position.
	self assert: 120 @ 150 equals: a position
]

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testNestedContainerBounds [

	| doc a b container innerContainer |
	doc := SBAlgebraCommand container
		morph: (container := Morph new hResizing: #shrinkWrap; vResizing: #shrinkWrap);
		data: {
			SBAlgebraCommand morph data: (a := Morph new extent: 80 @ 40).
			SBAlgebraCommand hardLine.
			SBAlgebraCommand container
				morph: (innerContainer := Morph new);
				data: {SBAlgebraCommand morph data: (b := Morph new)}}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 300.
	self assert: 0 @ 0 equals: a position.
	self assert: 0 @ 40 equals: b position.
	self assert: b extent equals: innerContainer extent.
	self assert: 80 @ 80 equals: container extent
]

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testNestedOptionalWrap [

	| doc a b c |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand morph data: (a := Morph new).
		SBAlgebraCommand softLine.
		SBAlgebraCommand group data: {
			SBAlgebraCommand morph data: (b := Morph new).
			SBAlgebraCommand softLine.
			SBAlgebraCommand morph data: (c := Morph new)}}.
	
	"SBAlgebraLayout new layoutDocument: doc limit: 300.
	self assert: 0 @ 0 equals: a position.
	self assert: a width @ 0 equals: b position.
	self assert: a width + b width @ 0 equals: c position."
	
	SBAlgebraLayout new layoutDocument: doc limit: a width + 1.
	self assert: 0 @ 0 equals: a position.
	self assert: 0 @ a height equals: b position.
	self assert: 0 @ (a height + b height) equals: c position.
	
	SBAlgebraLayout new layoutDocument: doc limit: a width + b width + 1.
	self assert: 0 @ 0 equals: a position.
	self assert: 0 @ a height equals: b position.
	self assert: a width @ (a height) equals: c position
]

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testNestedOptionalWrap2 [

	| doc a b c |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand group data: {
			SBAlgebraCommand morph data: (a := Morph new).
			SBAlgebraCommand softLine.
			SBAlgebraCommand group data: {
				SBAlgebraCommand morph data: (b := Morph new).
				SBAlgebraCommand indent data: {
					SBAlgebraCommand softLine.
					SBAlgebraCommand group data: {
						SBAlgebraCommand morph data: (c := Morph new)}}}}}.
	
	SBAlgebraLayout new layoutDocument: doc limit: a width + b width + 1.
	self assert: 0 @ 0 equals: a position.
	self assert: 0 @ a height equals: b position.
	self assert: b width @ a height equals: c position.
	
	SBAlgebraLayout new layoutDocument: doc limit: a width + 21.
	self assert: 0 @ 0 equals: a position.
	self assert: 0 @ a height equals: b position.
	self assert: 20 @ (a height + b height) equals: c position
]

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testOptionalWrap [

	| doc a b |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand morph data: (a := Morph new).
		SBAlgebraCommand softLine.
		SBAlgebraCommand morph data: (b := Morph new)}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 300.
	self assert: 0 @ 0 equals: a position.
	self assert: a width @ 0 equals: b position.
	
	SBAlgebraLayout new layoutDocument: doc limit: a width + 1.
	self assert: 0 @ 0 equals: a position.
	self assert: 0 @ a height equals: b position
]

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testSequentialContainerLineHeight [

	| doc a b |
	doc := SBAlgebraCommand group data: {
		SBAlgebraCommand container morph: (a := Morph new hResizing: #shrinkWrap; vResizing: #shrinkWrap); data: {SBAlgebraCommand morph data: (Morph new extent: 10 @ 80)}.
		SBAlgebraCommand container morph: (b := Morph new hResizing: #shrinkWrap; vResizing: #shrinkWrap); data: {SBAlgebraCommand morph data: (Morph new extent: 10 @ 30)}}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 300.
	self assert: 10 @ 80 equals: a extent.
	self assert: 10 @ 30 equals: b extent
]

{ #category : #'as yet unclassified' }
SBAlgebraLayoutTest >> testWrapAsSecondChild [

	| doc a b c |
	doc := SBAlgebraCommand container
		morph: (Morph new hResizing: #shrinkWrap; vResizing: #shrinkWrap);
		data: {
			SBAlgebraCommand container morph: (a := Morph new hResizing: #shrinkWrap; vResizing: #shrinkWrap); data: {SBAlgebraCommand morph data: (Morph new extent: 50 @ 20)}.
			SBAlgebraCommand container
				morph: (Morph new hResizing: #shrinkWrap; vResizing: #shrinkWrap);
				data: {
					SBAlgebraCommand container
						morph: Morph new;
						data: {
							SBAlgebraCommand morph data: (b := Morph new extent: 50 @ 20)}.
							SBAlgebraCommand softLine.
							SBAlgebraCommand morph data: (c := Morph new extent: 50 @ 20)}}.
	
	SBAlgebraLayout new layoutDocument: doc limit: 80.
	
	self assert: 0 @ 0 equals: a position.
	self assert: 50 @ 0 equals: b position.
	self assert: 50 @ 20 equals: c position
]
