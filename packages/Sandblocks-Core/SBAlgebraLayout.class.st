Class {
	#name : #SBAlgebraLayout,
	#superclass : #LayoutPolicy,
	#instVars : [
		'measure',
		'minExtentCache'
	],
	#category : #'Sandblocks-Core'
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
SBAlgebraLayout >> fitsDocument: command at: aState limit: maxRight [

	| state |
	^ command type caseOf: {
		[#group] -> [
			state := aState.
			command data do: [:el |
				state := self fitsDocument: el at: state limit: maxRight].
			state].
		[#indent] -> [self fitsDocument: (SBAlgebraCommand group data: command data) at: aState limit: maxRight].
		[#container] -> [ | inset |
			inset := command morph layoutInset asEdgeInsets.
			state := self
				fitsDocument: (SBAlgebraCommand group data: command data)
				at: (((aState offset: aState offset + inset topLeft lineHeight: inset top) startX: aState offset x + inset left) containerWidth: 0)
				limit: maxRight.
			state := (state offset: (state offset + (inset right @ 0)) lineHeight: state lineHeight + inset bottom) containerWidth: state containerWidth + inset right.
			((state
				offset: (state offset x max: state containerWidth) @ state offset y
				lineHeight: (state lineHeight max: aState lineHeight))
				startX: aState startX)
				containerWidth: (aState containerWidth max: state containerWidth) + inset right].
		[#hardLine] -> [aState offset: aState startX @ (aState offset y + aState lineHeight) lineHeight: 0].
		[#softLine] -> [aState].
		[#softLineOrGap] -> [aState offset: aState offset + (self gap @ 0)].
		[#gap] -> [aState offset: aState offset + (self gap @ 0)].
		[#morph] -> [ | extent |
			extent := command data minExtent.
			aState
				offset: aState offset + (extent x @ 0)
				lineHeight: (aState lineHeight max: extent y)].
		[#noop] -> [aState].
	}
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
	
	measure := false
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> isAlgebraLayoutRoot: aMorph [

	^ aMorph owner isNil or: [aMorph owner layoutPolicy class ~= SBAlgebraLayout]
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> layout: aMorph in: aRectangle [

	| final initial |
	(self isAlgebraLayoutRoot: aMorph) ifFalse: [^ self].
	
	initial := ((SBAlgebraState new offset: aRectangle topLeft) startX: aRectangle left).
	final := self
		layoutDocument: (self commandsForRoot: aMorph)
		at: initial
		limit: aRectangle right
		wrap: false.
	
	" if we do not have an owner, enforce our minSize ourselves"
	(aMorph owner isNil or: [aMorph owner layoutPolicy isNil]) ifTrue: [
		aMorph extent: ((final extentFrom: initial) max: aRectangle extent) + aMorph layoutInset asEdgeInsets]
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> layoutDocument: command at: aState limit: maxRight wrap: aWrapBoolean [

	| state |
	^ command type caseOf: {
		[#group] -> [ | fits |
			state := aState.
			fits := (self fitsDocument: command at: aState limit: maxRight) offset x <= maxRight.
			command data do: [:el |
				state := self layoutDocument: el at: state limit: maxRight wrap: fits not].
			state].
		[#indent] -> [
			state := aState startX: aState startX + self indent.
			state := self layoutDocument: (SBAlgebraCommand group data: command data) at: state limit: maxRight wrap: aWrapBoolean.
			state startX: state startX - self indent].
		[#container] -> [ | inset |
			inset := command morph layoutInset asEdgeInsets.
			state := self
				layoutDocument: (SBAlgebraCommand group data: command data)
				at: (((aState offset: aState offset + inset topLeft lineHeight: inset top) startX: aState offset x + inset left) containerWidth: 0)
				limit: maxRight
				wrap: aWrapBoolean.
			state := (state offset: (state offset + (inset right @ 0)) lineHeight: state lineHeight + inset bottom) containerWidth: state containerWidth + inset right.
			
			measure ifFalse: [command morph layoutInBounds: (aState offset extent: ((state extentFrom: aState) max: 0 @ command morph minimumHeight))].
			((state
				offset: (state offset x max: state containerWidth) @ state offset y
				lineHeight: ((state lineHeight max: aState lineHeight) max: command morph minimumHeight))
				startX: aState startX)
				containerWidth: (aState containerWidth max: state containerWidth) + inset right].
		[#hardLine] -> [
			(aState offset: aState startX @ (aState offset y + aState lineHeight + (command withGap ifTrue: [self gap] ifFalse: [0])) lineHeight: 0) containerWidth: (aState containerWidth max: aState offset x)].
		[#softLine] -> [
			aWrapBoolean
				ifTrue: [self layoutDocument: (SBAlgebraCommand hardLine withGap: command withGap) at: aState limit: maxRight wrap: aWrapBoolean]
				ifFalse: [aState]].
		[#softLineOrGap] -> [
			aWrapBoolean
				ifTrue: [self layoutDocument: (SBAlgebraCommand hardLine withGap: command withGap) at: aState limit: maxRight wrap: aWrapBoolean]
				ifFalse: [aState offset: aState offset + (self gap @ 0)]].
		[#gap] -> [aState offset: aState offset + (self gap @ 0)].
		[#morph] -> [ | extent |
			extent := command data minExtent.
			measure ifFalse: [command data bounds: (aState offset extent: extent)].
			aState
				offset: aState offset + (extent x @ 0)
				lineHeight: (aState lineHeight max: extent y)].
		[#noop] -> [aState].
	}
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> layoutDocument: command limit: aNumber [

	^ self layoutDocument: command at: SBAlgebraState new limit: aNumber wrap: false
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> minExtentOf: aMorph in: aRectangle [

	| state initial commands minExtent |
	minExtentCache ifNotNil: [^ minExtentCache].
	
	commands := self commandsForRoot: aMorph.
	(commands type = #morph and: [commands data = aMorph]) ifTrue: [^ aRectangle extent].
	
	initial := ((SBAlgebraState new offset: aRectangle topLeft) startX: aRectangle left).
	measure := true.
	state := self layoutDocument: commands at: initial limit: aRectangle right wrap: false.
	measure := false.
	
	" bit of a hack here: since our height depends on our width, we cannot generally just report
	  the final result, as this would for example give us too much height. instead we choose a
	  small threshold that we can assume our layout will be able to be condensed into and
	  only start reporting proper min widths if the provided space is less than that "
	minExtent := state extentFrom: initial.
	^ minExtentCache := "aRectangle width <= minExtent x"true
		ifTrue: [state extentFrom: initial]
		ifFalse: [50 @ (state extentFrom: initial) y]
]
