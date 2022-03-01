An SBJsReactComponentWrapper wraps a class declaration AST node of Javascript (a SBInlineBlockSequence). It can be used to access the relevant parts of the given class for the replacements used in the Sandblocks-JavascriptReact.

To access these relevant parts like the wrapped component's name, it uses tree sitter queries. 
The wrapper has methods to access specific parts of the component alone like the component name. (Currently, no other specific methods are needed.)
Additionally, it also provides a method that extracts all relevant parts into one dictionary using the same query the SBJsReactExamplesReplacement used in its match method. This is useful when needing to access multiple of the relevant properties of the component by only executing a single tree sitter query. It is mainly used for the html file generation of the SBJsReactJSXElementReplacement.

Instance Variables
	reactComponent:		<SBInlineBlockSymbol>

reactComponent
	- An AST node (SBInlineBlockSequence) of type 'class_declaration' whose class must contain a render method, an examples-array and inherit from React.Component.
	
Interesting points where to start:
- The method query executes a given tree sitter query on itss reactComponent and returns its captures.
- The method allCaptures executes the same query the SBJsReactExamplesReplacement uses to detect its replacement to capture all necessary parts of the reactComponent used in this project. It returns the all captures. Note that this uses a slighty modified version of the query where the examples array is optionally. This is needed because the examples array might have been replaced by a SBJsReactExamplesReplacement and therefore a query where the examples array must exist would fail.