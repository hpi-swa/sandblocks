Class {
	#name : #SBJsComponentReplacement,
	#superclass : #SBInlineBlockReplace,
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> exampleHTMLTemplateFor: aSourceCodeString forClass: aClassNameString withOptions: aObjectString [

	^ '<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />

    <meta
      name="description"
      content="Web site created using create-react-app"
    />
    <title>Example</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root">hello world</div>
    <script src="https://fb.me/react-0.14.3.js"></script>
    <script src="https://fb.me/react-dom-0.14.3.js"></script>
    <script src="https://unpkg.com/babel-standalone@6/babel.min.js"></script>
    <script type="text/babel">
      ReactDOM.render(<div id="container"></div>, document.getElementById("root"));
',
	aSourceCodeString,
	'
	const options = ', aObjectString, ';
	const { componentProps } = options;
	ReactDOM.render(<' , aClassNameString , ' {...componentProps} />, document.getElementById("container"));
    </script>
  </body>
</html>'
	
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> getTestHTMLFilePath [

	 ^ '/Users/michael/Desktop/test.html'
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> matchJs: aDictionary do: aBlock [
	<lang: #javascript match: '(class_declaration
    name: (identifier) @class_name
    body: (class_body
    	(field_definition
        	(property_identifier) @example_name
	      (object) @options
        ) @example_object
	(method_definition
        	(property_identifier) @method_name
  	)
    )
) @class'>
	| wholeReactClass reactClassName options htmlFileContents |
	"(aDictionary at: 'example_name') contents = 'example' ifFalse: [^ nil]."
	(aDictionary at: 'method_name') contents = 'render' ifFalse: [^ nil].
	wholeReactClass := aDictionary at: 'class'. 
	reactClassName := (aDictionary at: 'class_name') contents.
	options := (aDictionary at: 'options').
	Transcript showln: wholeReactClass sourceString.
	htmlFileContents := (self exampleHTMLTemplateFor: wholeReactClass sourceString forClass: reactClassName withOptions: options sourceString).
	htmlFileContents := htmlFileContents copyReplaceAll: 'h2style' with: 'h2 style'.
	FileStream forceNewFileNamed: self getTestHTMLFilePath do: [:stream | stream nextPutAll: htmlFileContents].
	
	"First argument: What will be replaced, second argument: With what it will be replaced."
	 ^ aBlock
		value: (aDictionary at: 'example_object')
		value: (self new exampleObject: (aDictionary at: 'example_object') url: 'file://' , self getTestHTMLFilePath)
		
	

]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> sampleReactClassAsString [

	 ^ 'class Car extends React.Component {
 	example = {};
	render(){
		return <h2>Hi, I am a Car! </h2>;
	}
}'
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement >> exampleObject: aJsObjectString url: aString [
	
	self
		listDirection: #topToBottom;
		addMorphBack: (SBRow new
			addMorphBack: (MMBrowserMorph reactOpenOn: aString);
			addMorphBack: aJsObjectString buildCopy).
			"addMorphBack: (SBTextBubble new contents: aString))"
		
	

]
