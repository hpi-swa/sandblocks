"
A SBAlgebraLayout is a layout policy that calls uses Commands to arrive at a layout. For example, a command could be #softLine, instructing the layout to only place a linebreak here if there is not enough horizontal space otherwise.

Each Morph can implement #layoutCommands, which must return a SBAlgebraCommand. If you want to use the SBAlgebraLayout, assign this layoutPolicy to all morphs in your subtree. The layoutPolicy will then take care that only the topmost layout will actually perform any positioning (#isAlgebraLayoutRoot:).

The algorithm is based on this paper: http://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf
See also this article for a simple explanation: https://blog.vjeux.com/2017/javascript/anatomy-of-a-javascript-pretty-printer.html
"
Class {
	#name : #SBAlgebraLayout,
	#superclass : #LayoutPolicy,
	#instVars : [
		'measure',
		'minExtentCache',
		'cache'
	],
	#category : #'Sandblocks-Layout'
}

{ #category : #'as yet unclassified' }
SBAlgebraLayout class >> gap [

	^ 4
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout class >> indent [

	^ 20
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> commandsForRoot: aMorph [

	| commands |
	commands := aMorph layoutCommands.
	" our root morph needs to be casted to a group, since we cannot move our root morph as part of layouting "
	(commands type = #container and: [commands morph = aMorph" and: [commands morph owner notNil]"])
		ifTrue: [commands := commands copy type: #group].
	^ commands
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> flushLayoutCache [

	minExtentCache := nil
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> gap [

	^ self class gap
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> indent [

	^ self class indent
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> initialize [

	super initialize.
	
	measure := false.
	cache := Dictionary new
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> isAlgebraLayoutRoot: aMorph [

	^ aMorph owner isNil or: [aMorph owner layoutPolicy class ~= SBAlgebraLayout]
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> layout: aMorph in: aRectangle [

	| final initial |
	(self isAlgebraLayoutRoot: aMorph) ifFalse: [^ self].
	
	cache := Dictionary new.
	
	initial := SBAlgebraState new
		offset: aRectangle topLeft
		lineHeight: 0
		startX: aRectangle left
		containerBottomRight: aRectangle topLeft.
	final := self
		layoutDocument: (self commandsForRoot: aMorph)
		at: initial
		limit: aRectangle right
		wrap: false
		lineHeight: 0.
	
	cache := nil.
	
	" if we do not have an owner, enforce our minSize ourselves"
	(aMorph owner isNil or: [aMorph owner layoutPolicy isNil]) ifTrue: [aMorph extent: ((final containerExtentFrom: initial) max: aRectangle extent) + aMorph layoutInset asEdgeInsets]
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> layoutDocument: command at: aState limit: maxRight wrap: aWrapBoolean lineHeight: aNumber [

	| state extent extra |
	^ command type caseOf: {
		[#group] -> [ | fits height |
			fits := self lineFitsDocument: command at: aState limit: maxRight lineHeight: [:h | height := h].
			command data
				inject: aState
				into: [:s :el | self layoutDocument: el at: s limit: maxRight wrap: fits not lineHeight: height]].
		[#indent] -> [
			state := aState startX: aState startX + self indent.
			state := self
				layoutDocument: (SBAlgebraCommand group data: command data)
				at: state
				limit: maxRight
				wrap: aWrapBoolean
				lineHeight: aNumber.
			state startX: state startX - self indent].
		[#container] -> [
			state := aState nestedInset: command morph layoutInset asEdgeInsets do: [:shiftedState |
				self
					layoutDocument: (SBAlgebraCommand group data: command data)
					at: shiftedState
					limit: maxRight
					wrap: aWrapBoolean
					lineHeight: 0].
			
			extent := (state containerExtentFrom: aState) max: 0 @ command morph minimumHeight.
			extra := 0 @ (aNumber > 0 ifTrue: [(aNumber // 2) - (extent y // 2)] ifFalse: [0]).
			measure ifFalse: [command morph layoutInBounds: (aState offset + extra extent: extent)].
			
			aState placeSized: extent].
		[#hardLine] -> [aState newLineWithGap: command withGap].
		[#softLine] -> [
			aWrapBoolean
				ifTrue: [
					self
						layoutDocument: (SBAlgebraCommand hardLine withGap: command withGap)
						at: aState
						limit: maxRight
						wrap: aWrapBoolean
						lineHeight: 0]
				ifFalse: [aState]].
		[#softLineOrGap] -> [
			aWrapBoolean
				ifTrue: [
					self
						layoutDocument: (SBAlgebraCommand hardLine withGap: command withGap)
						at: aState
						limit: maxRight
						wrap: aWrapBoolean
						lineHeight: 0]
				ifFalse: [aState offset: aState offset + (self gap @ 0)]].
		[#gap] -> [aState offset: aState offset + (self gap @ 0)].
		[#morph] -> [
			extent := command data minExtent.
			extra := 0 @ (aNumber > 0 ifTrue: [(aNumber // 2) - (extent y // 2)] ifFalse: [0]).
			measure ifFalse: [command data bounds: (aState offset + extra extent: extent)].
			aState placeSized: extent].
		[#noop] -> [aState]}
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> layoutDocument: command limit: aNumber [

	^ self layoutDocument: command at: SBAlgebraState new limit: aNumber wrap: false lineHeight: 0
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> lineFitsDocument: command at: aState limit: maxRight [

	| state |
	^ cache at: {aState. command} ifAbsentPut: [
		state := command type caseOf: {
			[#group] -> [command data inject: aState into: [:s :el | self lineFitsDocument: el at: s limit: maxRight]].
			[#indent] -> [self lineFitsDocument: (SBAlgebraCommand group data: command data) at: aState limit: maxRight].
			[#container] -> [
				state := aState
					nestedInset: command morph layoutInset asEdgeInsets
					do: [:shiftedState | self lineFitsDocument: (SBAlgebraCommand group data: command data) at: shiftedState limit: maxRight].
				aState placeSized: ((state containerExtentFrom: aState) max: 0 @ command morph minimumHeight)].
			[#hardLine] -> [aState newLineWithGap: command withGap].
			[#softLine] -> [aState].
			[#softLineOrGap] -> [aState offset: aState offset + (self gap @ 0)].
			[#gap] -> [aState offset: aState offset + (self gap @ 0)].
			[#morph] -> [aState placeSized: command data minExtent].
			[#noop] -> [aState]}.
		self flag: #fixme.
		" is an early exit worth the extra complexity? "
		"state offset x > maxRight ifTrue: [^ aBlock value]."
		state]
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> lineFitsDocument: command at: aState limit: maxRight lineHeight: aBlock [

	| lineBreaks endState softLineBreaks fits |
	lineBreaks := command data anySatisfy: [:cmd | cmd type = #hardLine].
	softLineBreaks := command data anySatisfy: [:cmd | cmd type = #softLine or: [cmd type = #softLineOrGap]].
	endState := self lineFitsDocument: command at: aState limit: maxRight.
	fits := endState notNil and: [endState offset x <= maxRight].
	aBlock value: ((lineBreaks or: [fits not and: [SBToggledCode comment: '' active: 1 do: {[true]. [softLineBreaks]}]])
		ifTrue: [0]
		ifFalse: [(endState containerExtentFrom: aState) y]).
	^ lineBreaks not and: [fits]
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> minExtentOf: aMorph in: aRectangle [

	| state initial commands minExtent |
	minExtentCache ifNotNil: [^ minExtentCache].
	
	cache := Dictionary new.
	
	commands := self commandsForRoot: aMorph.
	(commands type = #morph and: [commands data = aMorph]) ifTrue: [^ aRectangle extent].
	
	initial := SBAlgebraState new offset: aRectangle topLeft lineHeight: 0 startX: aRectangle left containerBottomRight: aRectangle topLeft.
	measure := true.
	state := self layoutDocument: commands at: initial limit: aRectangle right wrap: false lineHeight: 0.
	measure := false.
	
	cache := nil.
	
	" bit of a hack here: since our height depends on our width, we cannot generally just report
	  the final result, as this would for example give us too much height. instead we choose a
	  small threshold that we can assume our layout will be able to be condensed into and
	  only start reporting proper min widths if the provided space is less than that "
	minExtent := state containerExtentFrom: initial.
	^ minExtentCache := "aRectangle width <= minExtent x"true
		ifTrue: [state containerExtentFrom: initial]
		ifFalse: [50 @ (state containerExtentFrom: initial) y]
]
