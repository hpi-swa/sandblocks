A SBJsComponentReplacement is a SBInlineBlockReplace for React Components that have a annotation for examples directly defined before their render method. The component needs to be a class and inherit from React.Component. Functional components are currently not supported. 
The annotation prior to the render method must be an assignment to the class variable "examples" in form of an array. This assignment will be replaced by this class.
Each entry in this array will be as one example in an independent MMBrowserMorph each. The MMBrowserMorph is directly below the example entry, which can be modified at will. But it should stay a valid JsObject in order for the example to work. The examples annotation must look like this: 
`examples = [{componentProps:{<props passed to the rendered component>}}, <maybe more entries>]`.
As the component is rendered inside a div in the example generated html page, it is possible to modify the div wrapping this component at free will. Just add property 'parentProps: {<options,,.>}' to the example object and the <options...> will be passed to that wrapping div.
Additionally, it is possible to have share properties between examples using a `sharedExampleProps = {<properties...>}` like annotation above the 'examples' annotation. The properties defined within the 'sharedExampleProps' can be accessed in the examples like it would be done with normal JS syntax.


Class Variables
	GeneratedHTMLFileDir		<String>
			
GeneratedHTMLFileDir
	- The directory where all generated files for the previews of examples should be saved at.
	

Interesting points where to start:
 - matchComponentExamples:do: This method tries to match for the examples annotation mentioned above in React.Component classes. If replaces each entry in the examples array with an example with a MMBrowserMorph. The examples are created in examplesFor: using newExample:withCaptures:filePath where the captures are a dict that contain the captures of the tree sitter query used to match the replacement.
- addNewEmptyExample is called once the addExample action is called on the render method SBInlineBlock to add a new example.

Dependency: A installed instance of the MagicMouse project in dev mode.
For better performance turn of the debugging flag in the settings.