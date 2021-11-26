Class {
	#name : #SBJsComponentReplacement,
	#superclass : #SBInlineBlockReplace,
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> exampleHTMLTemplateFor: aString forClass: anotherString [

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
      ReactDOM.render(<div id="container"></div>, document.getElementById("root"));',
	aString,
	'ReactDOM.render(<' , anotherString , '/>, document.getElementById("container"));
    </script>
  </body>
</html>'
	
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> getTestHTMLFilePath [

	 ^ '/home/michael/Desktop/test.html'
]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement class >> matchJs: aDictionary do: aBlock [
	<lang: #javascript match: '(class_declaration
    name: (identifier) @class_name
    body: (class_body
    	(field_definition
        	(property_identifier) @example_name
        ) @example_object
	(method_definition
        	(property_identifier) @method_name
  	)
    )
) @class'>
	| classa reactClassName |
	(aDictionary at: 'example_name') contents = 'example' ifFalse: [^ nil].
	(aDictionary at: 'method_name') contents = 'render' ifFalse: [^ nil].
	classa := aDictionary at: 'class'. 
	reactClassName := (aDictionary at: 'class_name') contents.
	Transcript showln: classa sourceString.
	FileStream forceNewFileNamed: self getTestHTMLFilePath do: [:stream | stream nextPutAll: (self exampleHTMLTemplateFor: classa sourceString forClass: reactClassName)].
	
	"First argument: What will be replaced, second argument: With what it will be replaced."
	 ^ aBlock
		value: (aDictionary at: 'example_object')
		value: (self new props: (aDictionary at: 'class_name') url: 'file://' , self getTestHTMLFilePath)
		
	

]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement >> props: aJsObjectString [
	
	self
		listDirection: #topToBottom;
		addMorphBack: (SBRow new
			addMorphBack: (SBStringMorph new contents: 'I am replacing an example object')
			"addMorphBack: (SBTextBubble new contents: aString)")
		
	

]

{ #category : #'as yet unclassified' }
SBJsComponentReplacement >> props: aJsObjectString url: aString [
	
	self
		listDirection: #topToBottom;
		addMorphBack: (SBRow new
			addMorphBack: (SBStringMorph new contents: 'I am replacing an example object');
			addMorphBack: (MMBrowserMorph openOn: aString)).
			"addMorphBack: (SBTextBubble new contents: aString))"
		
	

]
