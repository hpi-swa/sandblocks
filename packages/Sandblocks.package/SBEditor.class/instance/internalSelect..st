selection
internalSelect: aBlock

	| previousSelection |
	previousSelection := selection.
	selection := aBlock.
	
	" sometimes we don't have a layout yet, so wait a frame before we scroll wherever we need to "
	selection ifNotNil: [
		selection changed.
		selection wasSelected.
		Project current addDeferredUIMessage: [scroll scrollToShow: selection]].
	
	previousSelection ifNotNil: #changed.
	
	self triggerEvent: #selectionChanged with: selection.
	self updateSelectionLabel