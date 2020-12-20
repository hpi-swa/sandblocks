painting
drawSubmorphsOn: aCanvas

	[super drawSubmorphsOn: aCanvas] on: Error do: [:error | self triggerEvent: #reportError with: error]