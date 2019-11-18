as yet unclassified
drawSubmorphsOn: aCanvas

	aCanvas transformBy: transform clippingTo: self innerBounds during: [:canvas |
		super drawSubmorphsOn: canvas]