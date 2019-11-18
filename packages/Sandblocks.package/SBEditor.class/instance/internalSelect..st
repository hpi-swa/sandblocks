selection
internalSelect: aBlock

	| previousSelection |
	previousSelection := selection.
	aBlock
		ifNil: [
			selection := nil.
			previousSelection ifNotNil: #changed]
		ifNotNil: [
			selection := aBlock.
			previousSelection ifNotNil: #changed.
			selection changed.
			
			" sometimes we don't have a layout yet, so wait a frame before we scroll wherever we need to "
			Project current addDeferredUIMessage: [scroll scrollToShow: selection bounds]].
	(previousSelection notNil and: [previousSelection owner notNil] and: [previousSelection containingMethod ~= (aBlock ifNotNil: #containingMethod)]) ifTrue: [previousSelection containingMethod changed].
	aBlock ifNotNil: [aBlock containingMethod owner changed].
	self updateSelectionLabel