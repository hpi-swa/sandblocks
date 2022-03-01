inline-replacement
matchComponentExamples: aDictionary do: aBlock
	<lang: #javascript match: '(jsx_self_closing_element) @element'>

	| element jsxElementReplacement elementName blockToReplace |
	element := aDictionary at: 'element'.
	elementName := element access children first contents.
	jsxElementReplacement := SBJsReactComponentRegistry defaultRegistry componentReplacementForComponentName: elementName.
	jsxElementReplacement ifNil: [^ nil].
	blockToReplace := element owner owner class = self
		ifTrue: [element owner owner]
		ifFalse: [element].
	"First argument: What will be replaced, second argument: With what it will be replaced."
	^ aBlock value: blockToReplace value: (self new
		replacementFor: element
		withComponentWrapper: jsxElementReplacement componentWrapper
		withExampleImage: jsxElementReplacement previewImageCopy)