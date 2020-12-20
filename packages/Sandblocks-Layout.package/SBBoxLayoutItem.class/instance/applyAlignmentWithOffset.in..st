layout
applyAlignmentWithOffset: offsetPoint in: nonLayoutSize

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