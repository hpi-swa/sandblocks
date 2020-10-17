"
A PHBoxLayoutItem is a helper class internally used by the box layout to save intermediate calculation results. It is essentialy a tuple of data with some logic for allocating widgets in its space.
"
Class {
	#name : #SBBoxLayoutItem,
	#superclass : #Object,
	#instVars : [
		'minSize',
		'naturalSize',
		'maxSize',
		'finalSize',
		'expanding',
		'widget',
		'offset',
		'vertical'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #layout }
SBBoxLayoutItem >> applyAlignmentWithOffset: offsetPoint in: nonLayoutSize [

	| destBox wanted available preferred |
	available := finalSize @ nonLayoutSize.
	
	vertical ifTrue: [available := available transposed].
	
	preferred := self widget preferredSizeForWidth: available x.
	wanted := (preferred naturalSize min: available) max: preferred minSize.
	"wanted := self widget adjustAllocatedSize: wanted."
	
	destBox := offsetPoint + (vertical ifTrue: [0 @ offset] ifFalse: [offset @ 0]) extent: wanted.
	
	(#(topCenter bottomCenter center) includes: widget cellPositioning) ifTrue: [destBox := destBox translateBy: ((available x / 2) - (wanted x / 2) @ 0) floor].
	(#(rightCenter leftCenter center) includes: widget cellPositioning) ifTrue: [destBox := destBox translateBy: 0 @ ((available y / 2) - (wanted y / 2)) floor].
	
	self flag: #todo.
	"widget align first == #fill ifTrue: [destBox := destBox withWidth: available x].
	widget align second == #fill ifTrue: [destBox := destBox withHeight: available y]."
	
	(#(rightCenter topRight bottomRight) includes: widget cellPositioning) ifTrue: [destBox := destBox translateBy: available x - destBox width @ 0].
	(#(bottomCenter bottomLeft bottomRight) includes: widget cellPositioning) ifTrue: [destBox := destBox translateBy: 0 @ (available y - destBox height)].
	
	widget bounds: destBox
]

{ #category : #accessing }
SBBoxLayoutItem >> expanding [

	^ expanding
]

{ #category : #accessing }
SBBoxLayoutItem >> expanding: aBoolean [

	expanding := aBoolean
]

{ #category : #accessing }
SBBoxLayoutItem >> finalSize [

	^ finalSize
]

{ #category : #accessing }
SBBoxLayoutItem >> finalSize: aNumber [

	finalSize := aNumber
]

{ #category : #layout }
SBBoxLayoutItem >> inVerticalLayout: aBoolean [

	vertical := aBoolean.
	
	self expanding:
		((self morph: self widget wantsExpandIn: aBoolean) at: (aBoolean ifTrue: [2] ifFalse: [1]))
		"((self widget wantsExpandIn: aBoolean) at: (aBoolean ifTrue: [2] ifFalse: [1]))"
]

{ #category : #accessing }
SBBoxLayoutItem >> initialize [

	super initialize.
	
	self minSize: 0 @ 0
]

{ #category : #accessing }
SBBoxLayoutItem >> maxSize [

	^ maxSize
]

{ #category : #accessing }
SBBoxLayoutItem >> maxSize: aNumber [

	maxSize := aNumber
]

{ #category : #accessing }
SBBoxLayoutItem >> minSize [

	^ minSize
]

{ #category : #accessing }
SBBoxLayoutItem >> minSize: aNumber [

	minSize := aNumber
]

{ #category : #layout }
SBBoxLayoutItem >> morph: aMorph wantsExpandIn: aVerticalBoolean [

	^ {aMorph vResizing = #spaceFill. aMorph hResizing = #spaceFill}
	"((aMorph wantsExpandIn: aBoolean) at: (aBoolean ifTrue: [2] ifFalse: [1]))"
]

{ #category : #accessing }
SBBoxLayoutItem >> naturalSize [

	^ naturalSize
]

{ #category : #accessing }
SBBoxLayoutItem >> naturalSize: aNumber [

	naturalSize := aNumber
]

{ #category : #layout }
SBBoxLayoutItem >> nonLayoutDirectionSizesForWidth: aNumber [

	| preferred |
	preferred := self widget preferredSizeForWidth: (vertical ifTrue: [aNumber] ifFalse: [aNumber max: self finalSize]).
	
	^ SBSizeRequest
		min: (vertical ifTrue: [preferred minSize x] ifFalse: [preferred minSize y])
		natural: (vertical ifTrue: [preferred naturalSize x] ifFalse: [preferred naturalSize y])
]

{ #category : #accessing }
SBBoxLayoutItem >> offset [

	^ offset
]

{ #category : #accessing }
SBBoxLayoutItem >> offset: aNumber [

	offset := aNumber
]

{ #category : #layout }
SBBoxLayoutItem >> takeWidth: aNumber [

	| preferred |
	preferred := self widget preferredSizeForWidth: aNumber.
	
	self
		minSize: (vertical ifTrue: [preferred minSize y] ifFalse: [preferred minSize x]);
		naturalSize: (vertical ifTrue: [preferred naturalSize y] ifFalse: [preferred naturalSize x]);
		finalSize: (vertical ifTrue: [preferred minSize y] ifFalse: [preferred minSize x])
]

{ #category : #accessing }
SBBoxLayoutItem >> widget [

	^ widget
]

{ #category : #accessing }
SBBoxLayoutItem >> widget: aWidget [

	widget := aWidget
]
