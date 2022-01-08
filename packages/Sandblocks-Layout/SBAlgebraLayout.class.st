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
		'cache',
		'placementStream'
	],
	#category : #'Sandblocks-Layout'
}

{ #category : #'as yet unclassified' }
SBAlgebraLayout class >> gap [

	^ 2
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
SBAlgebraLayout >> ensureLayouted: aMorph [
	"Normally, when a morph is layed-out, it only required local knowledge.
as such, when fullBounds is called, only the local morph may compute a layout.
in the case of the AlgebraLayout, the local morph has no clue where it actually is,
unless it is a layout root morph.

Through this hook, we get a generic way of verifying that a layout for a local morph
is indeed computed, by asking its root morph to ensure its layout."

	(aMorph orOwnerSuchThat: [:o | o owner isNil or: [o owner layoutPolicy class ~= SBAlgebraLayout]]) fullBounds
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

	| final initial placements |
	(self isAlgebraLayoutRoot: aMorph) ifFalse: [^ self].
	
	cache := Dictionary new.
	
	initial := SBAlgebraState new
		offset: aRectangle topLeft
		lineHeight: 0
		startX: aRectangle left
		containerBottomRight: aRectangle topLeft.
	placements := Array streamContents: [:stream |
		placementStream := stream.
		final := self
			layoutDocument: (self commandsForRoot: aMorph)
			at: initial
			limit: aRectangle right
			wrap: false].
	
	cache := nil.
	placements do: [:pair | pair first layoutInBounds: pair second].
	
	" if we do not have an owner, enforce our minSize ourselves"
	(aMorph owner isNil or: [aMorph owner layoutPolicy isNil]) ifTrue: [aMorph extent: ((final containerExtentFrom: initial) max: aRectangle extent) + aMorph layoutInset asEdgeInsets]
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> layoutDocument: command at: aState limit: maxRight wrap: aWrapBoolean [

	| state |
	^ command type caseOf: {
		[#group] -> [ | fits |
			fits := self lineFitsDocument: command at: aState limit: maxRight.
			command data
				inject: aState
				into: [:s :el | self layoutDocument: el at: s limit: maxRight wrap: fits not]].
		[#indent] -> [
			state := aState startX: aState startX + self indent.
			state := self
				layoutDocument: (SBAlgebraCommand group data: command data)
				at: state
				limit: maxRight
				wrap: aWrapBoolean.
			state startX: state startX - self indent].
		[#looseContainer] -> [
			state := aState looseInset: command morph layoutInset asEdgeInsets do: [:shiftedState |
				self
					layoutDocument: (SBAlgebraCommand group data: command data)
					at: shiftedState
					limit: maxRight
					wrap: aWrapBoolean].
			
			measure ifFalse: [
				SBToggledCode comment: '' active: 2 do: {
					[
						placementStream nextPut: {
							command morph.
							aState offset extent: ((state containerExtentFrom: aState) max: 0 @ command morph minimumHeight).
							false}].
					[command morph layoutInBounds: (aState offset extent: ((state containerExtentFrom: aState) max: 0 @ command morph minimumHeight))]}].
			
			aState placeSized: ((state containerExtentFrom: aState) max: 0 @ command morph minimumHeight)].
		[#container] -> [
			state := aState nestedInset: command morph layoutInset asEdgeInsets do: [:shiftedState |
				self
					layoutDocument: (SBAlgebraCommand group data: command data)
					at: shiftedState
					limit: maxRight
					wrap: aWrapBoolean].
			
			measure ifFalse: [command morph layoutInBounds: (aState offset extent: ((state containerExtentFrom: aState) max: 0 @ command morph minimumHeight))].
			
			aState placeSized: ((state containerExtentFrom: aState) max: 0 @ command morph minimumHeight)].
		[#hardLine] -> [aState newLineWithGap: command withGap].
		[#softLine] -> [
			aWrapBoolean
				ifTrue: [
					self
						layoutDocument: (SBAlgebraCommand hardLine withGap: command withGap)
						at: aState
						limit: maxRight
						wrap: aWrapBoolean]
				ifFalse: [aState]].
		[#softLineOrGap] -> [
			aWrapBoolean
				ifTrue: [
					self
						layoutDocument: (SBAlgebraCommand hardLine withGap: command withGap)
						at: aState
						limit: maxRight
						wrap: aWrapBoolean]
				ifFalse: [aState offset: aState offset + (self gap @ 0)]].
		[#gap] -> [aState offset: aState offset + (self gap @ 0)].
		[#morph] -> [ | extent |
			extent := command data minExtent.
			measure ifFalse: [
				SBToggledCode comment: '' active: 2 do: {
					[{command data. aState offset extent: extent. true}].
					[command data bounds: (aState offset extent: extent)]}].
			aState placeSized: extent].
		[#noop] -> [aState]}
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> layoutDocument: command limit: aNumber [

	^ self layoutDocument: command at: SBAlgebraState new limit: aNumber wrap: false
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> lineFitsDocument: command at: aState limit: maxRight [

	^ (self lineFitsDocument: command at: aState limit: maxRight ifNot: [^ false]) offset x <= maxRight
]

{ #category : #'as yet unclassified' }
SBAlgebraLayout >> lineFitsDocument: command at: aState limit: maxRight ifNot: aBlock [

	| state |
	^ cache at: {aState. command} ifAbsentPut: [
		state := command type caseOf: {
			[#group] -> [
				command data
					inject: aState
					into: [:s :el | self lineFitsDocument: el at: s limit: maxRight ifNot: [^ aBlock value]]].
			[#indent] -> [
				self
					lineFitsDocument: (SBAlgebraCommand group data: command data)
					at: aState
					limit: maxRight
					ifNot: [^ aBlock value]].
			[#container] -> [
				state := aState nestedInset: command morph layoutInset asEdgeInsets do: [:shiftedState |
					self
						lineFitsDocument: (SBAlgebraCommand group data: command data)
						at: shiftedState
						limit: maxRight
						ifNot: [^ aBlock value]].
				aState placeSized: (state containerExtentFrom: aState)].
			[#looseContainer] -> [
				state := aState looseInset: command morph layoutInset asEdgeInsets do: [:shiftedState |
					self
						lineFitsDocument: (SBAlgebraCommand group data: command data)
						at: shiftedState
						limit: maxRight
						ifNot: [^ aBlock value]].
				aState placeSized: (state containerExtentFrom: aState)].
			[#hardLine] -> [aState newLineWithGap: command withGap].
			[#softLine] -> [aState].
			[#softLineOrGap] -> [aState offset: aState offset + (self gap @ 0)].
			[#gap] -> [aState offset: aState offset + (self gap @ 0)].
			[#morph] -> [aState placeSized: command data minExtent].
			[#noop] -> [aState]}.
		state offset x > maxRight ifTrue: [^ aBlock value].
		state]
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
	state := self layoutDocument: commands at: initial limit: aRectangle right wrap: false.
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
