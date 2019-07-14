as yet unclassified
newFrom: aMessage

	^ self new colorContents: (Color perform: aMessage selector asSymbol withArguments: (aMessage arguments collect: [:arg | arg contents asNumber] as: Array))