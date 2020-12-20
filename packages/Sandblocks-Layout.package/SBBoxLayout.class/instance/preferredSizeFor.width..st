layout
preferredSizeFor: aWidget width: aNumber

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