accessing
componentReplacementForComponentName: aString

	self componentRegistry do: [:catgoryEntries | catgoryEntries keysAndValuesDo: [:componentName :jsxElementReplacement | componentName = aString ifTrue: [^ jsxElementReplacement]]].
	^ nil