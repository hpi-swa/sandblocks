An SBJsReactJSXElementReplacement is a SBInlineBlockReplace that replaces the usage of a React Component as a JSX element directly within the code.
It can be created by creating a preview example for a component using the SBJsComponentReplacement and using its "add to palette" functionality. This will automatically create an instance of this class that references the example's component together with the props set for this example. During instantiation, a screenshot of the example is created using the SBJsReactExampleScreenshotTaker. The new instance is then automatically saved to the SBJsReactComponentRegistry's defaultRegistry.

The class tries to match every jsx element in javascript code and compares the element's component's name with the currently existing SBJsReactComponentRegistry defaultRegistry. If it finds an entry with a matching name, it takes a copy of the registered component's screenshot and with this creates an instance of this class to replace the jsx element. The replaced version still keeps the editable jsx code but also shows the screenshot above the code. This should make it easier to understand what the component visually represents.


Instance Variables
	componentWrapper		<SBJsReactComponentWrapper>

componentRegistry
	- An SBJsReactComponentWrapper referencing the AST nodes of the component used by this jsx element replacement. The wrapper is used to access certain parts of the referenced component on demand. E.g. get the whole source code of the referenced component in case the component where this replacement is in needs to generate an html example file for an example in an SBJsReactExamplesReplacement.

Interesting points where to start:
- The class methode for:withExample: is used to take the screenshot of a given component using the component's SBJsReactComponentWrapper and an example of it. After taking the screenshot the new instance of this class is returned.
- The class method matchComponentExamples:do: scans the javascript code for possible jsx element replacement using this class. This method covers the second paragraph described above.