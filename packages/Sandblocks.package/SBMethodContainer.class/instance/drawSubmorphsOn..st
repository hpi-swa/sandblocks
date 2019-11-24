as yet unclassified
drawSubmorphsOn: aCanvas

	super drawSubmorphsOn: aCanvas.
	
	aCanvas clipBy: self bounds during: [:clippedCanvas |
		overlayDrawBlocks do: [:block | block value: clippedCanvas]]