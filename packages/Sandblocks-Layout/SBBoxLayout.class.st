"
A BoxLayout is a layout policy laying out its children in one direction according to a height-for-width algorithm.

Each widget is asked a minimum and a natural size, which it is supposed to return via its `preferredSizeOf:in:` function. The layout then makes sure its container is at least the minimum size. If there is left-over space, we first try to make as many widgets as possible their natural size and attribute the rest of the space evenly to all widgets that have `expand` set to true.

Possible optimizations:
- cache queries to our minimumSizeOf:in:
- collect all the valid children once at the start
"
Class {
	#name : #SBBoxLayout,
	#superclass : #SBLayoutPolicy,
	#instVars : [
		'vertical',
		'totalMin',
		'totalNat',
		'expand',
		'hasHeightForWidth',
		'expanderCount',
		'childItems',
		'nonLayoutDirectionSizes'
	],
	#category : #'Sandblocks-Layout'
}

{ #category : #examples }
SBBoxLayout class >> exampleCenteredBox [

	| window loginPage loginBox |
	loginBox := (PHPage new vertical: true; align: #(center center)) color: Color green; minSize: 100 asPoint.
	loginPage := PHPage new color: Color red; add: loginBox.
	window := PHTopLevel new size: 600 asPoint; padding: 0; add: loginPage.
	window openInWorld
]

{ #category : #examples }
SBBoxLayout class >> exampleHeightForWidth [

	PHTopLevel new add: (PHLabel text: 'lorem ipsum dolor sit amet consetetur arum darum dolore imit census clericus lapradus'); openInWorld
]

{ #category : #examples }
SBBoxLayout class >> exampleSimpleChat [

	| window picture text |
	picture := PHWidget new color: Color green; minSize: 64 asPoint.
	text := PHLabel text: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.'.
	
	window := PHTopLevel new vertical: false; size: 600 asPoint; padding: 15; add: picture; add: text.
	window openInWorld
]

{ #category : #private }
SBBoxLayout >> distributeLeftOver: aNumber among: aCollection [

	| spreading extraSpace |
	aNumber <= 0 ifTrue: [^ 0].
	
	spreading := (1 to: aCollection size) asOrderedCollection.
	extraSpace := aNumber.
	
	spreading sort: [ :index1 :index2 | | sizes1 sizes2 delta1 delta2 delta |
		sizes1 := aCollection at: index1.
		sizes2 := aCollection at: index2.
		delta1 := sizes1 naturalSize - sizes1 minSize.
		delta2 := sizes2 naturalSize - sizes2 minSize.
		delta := delta2 - delta1.
		delta == 0 ifTrue: [delta := index2 - index1].
		delta < 0 ].
	
	(1 to: aCollection size) reverseDo: [ :index | | item extra gap glue |
		extraSpace > 0 ifTrue: [
			item := aCollection at: (spreading at: index).
			glue := (extraSpace + index - 1 / index) floor.
			gap := item naturalSize - item minSize.
			extra := glue min: gap.
			item finalSize: item finalSize + extra.
			extraSpace := extraSpace - extra]].
	
	^ extraSpace
]

{ #category : #private }
SBBoxLayout >> flipPoint: aPoint [
	" this function makes sure that the primary direction is always in the x spot of the 
	  point for easier handling in code that needs to be aware of both vertical and horizontal "
	
	^ vertical ifTrue: [aPoint y @ aPoint x] ifFalse: [aPoint]
]

{ #category : #layout }
SBBoxLayout >> layout: aWidget in: aBox [

	| nonLayoutDirectionMin offset preferred minSize |
	preferred := self preferredSizeFor: aWidget width: (aBox width max: aWidget minimumWidth).
	preferred minSize x > aBox width ifTrue: [" fixme. ouch. can anyone think of a better way to accomodate for children forcing a larger min width? "
	preferred := self preferredSizeFor: aWidget width: preferred minSize x].
	
	vertical ifTrue: [ | stillLeftOver extraExpanderSpace |
		stillLeftOver := self distributeLeftOver: aBox height - totalMin among: childItems.
		extraExpanderSpace := (expanderCount < 1
			ifTrue: [0]
			ifFalse: [stillLeftOver / expanderCount]) floor.
		childItems do: [:item | item finalSize: item finalSize + (item expanding ifTrue: [extraExpanderSpace] ifFalse: [0])]].
	
	minSize := (preferred minSize max: aBox extent) max: aWidget minimumExtent.
	nonLayoutDirectionMin := (self flipPoint: minSize) y.
	aBox extent ~= minSize ifTrue: [aWidget layoutBounds: (aBox origin extent: minSize)].
	
	offset := 0.
	childItems do: [:child |
		child
			offset: offset;
			applyAlignmentWithOffset: aBox origin in: nonLayoutDirectionMin.
		offset := offset + child finalSize + aWidget cellGap]
]

{ #category : #layout }
SBBoxLayout >> minExtentOf: aMorph in: aRectangle [

	^ (self preferredSizeFor: aMorph width: aRectangle width) minSize
]

{ #category : #private }
SBBoxLayout >> morph: aMorph wantsExpandIn: aVerticalBoolean [

	^ {aMorph vResizing = #spaceFill. aMorph hResizing = #spaceFill}
	"((aMorph wantsExpandIn: aBoolean) at: (aBoolean ifTrue: [2] ifFalse: [1]))"
]

{ #category : #layout }
SBBoxLayout >> preferredSizeFor: aWidget width: aNumber [

	| spacing stillLeftOver extraExpanderSpace nonLayoutDirectionMinSize nonLayoutDirectionNatSize absoluteMin children |
	vertical := aWidget listDirection = #topToBottom.
	children := self layoutMorphsOf: aWidget.
	spacing := children size - 1 * (aWidget cellGap * PHStyleContext scalingFactor).
	expand := {false. false}.
	expanderCount := 0.
	totalMin := totalNat := spacing.
	absoluteMin := 0.
	
	" initialize our list of items, count expanders "
	childItems := children collect: [:child | | item  |
		item := SBBoxLayoutItem new widget: child.
		item inVerticalLayout: vertical.
		
		" check if a child will force this layout to request expand "
		(expand first and: [expand second]) ifFalse: [ | childExpand |
			childExpand := self morph: child wantsExpandIn: vertical.
			expand := {expand first or: [childExpand first]. expand second or: [childExpand second]}].
		
		item expanding ifTrue: [expanderCount := expanderCount + 1].
		vertical ifFalse: [
			item minSize: (child preferredSizeForWidth: 0) minSize.
			absoluteMin := absoluteMin + item minSize x].
		item].
	
	childItems size < 0 ifTrue: [^ PHSizeRequest fixed: 0 asPoint].
	
	" give each child a tentative amount of space.
	  vertical case is easy: just give our container width and see what height we get
	  for horizontal we divide the space up evenly, preferring expanders if we have any "
	childItems do: [:item |
		vertical
			ifTrue: [item takeWidth: aNumber]
			ifFalse: [ | space |
				space := (aNumber / (expanderCount > 0 ifTrue: [expanderCount] ifFalse: [childItems size])) floor - absoluteMin max: 0.
				expanderCount > 0
					ifTrue: [item expanding ifTrue: [item takeWidth: space] ifFalse: [item takeWidth: 0]]
					ifFalse: [item takeWidth: space]].
		
		totalMin := totalMin + item minSize.
		totalNat := totalNat + item naturalSize].
	
	" attribute left over and expander space to reach final size in layout direction "
	vertical ifFalse: [
		stillLeftOver := self distributeLeftOver: aNumber - totalMin among: childItems.
		extraExpanderSpace := (expanderCount < 1 ifTrue: [0] ifFalse: [stillLeftOver / expanderCount]) floor.
		childItems do: [:item | item finalSize: item finalSize + (item expanding ifTrue: [extraExpanderSpace] ifFalse: [0])]].
	
	" calculate our size in the non layout direction "
	nonLayoutDirectionMinSize := 0.
	nonLayoutDirectionNatSize := 0.
	childItems do: [:item | | sizes |
		sizes := item nonLayoutDirectionSizesForWidth: (vertical ifTrue: [aNumber] ifFalse: [item finalSize]).
		nonLayoutDirectionMinSize := nonLayoutDirectionMinSize max: sizes minSize.
		nonLayoutDirectionNatSize := nonLayoutDirectionNatSize max: sizes naturalSize].
	
	^ PHSizeRequest
		min: (self flipPoint: totalMin @ nonLayoutDirectionMinSize)
		natural: (self flipPoint: totalNat @ nonLayoutDirectionNatSize)
]
