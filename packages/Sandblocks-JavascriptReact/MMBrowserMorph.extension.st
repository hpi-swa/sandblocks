Extension { #name : #MMBrowserMorph }

{ #category : #'*Sandblocks-JavascriptReact' }
MMBrowserMorph >> checkResize [

	| rect newExtent |
	rect := self image rectangleEnclosingPixelsNotOfColor: Color white.
	newExtent := rect bottomRight + rect topLeft.
	self extent: (rect bottomRight + rect topLeft max: 75 @ 75)
]

{ #category : #'*Sandblocks-JavascriptReact' }
MMBrowserMorph >> contents [

	^ ''
]

{ #category : #'*Sandblocks-JavascriptReact' }
MMBrowserMorph >> cursorIndexForPosition: aNumber [

	^ 0
]

{ #category : #'*Sandblocks-JavascriptReact' }
MMBrowserMorph >> cursorPosition [

	^ 0 @ 0
]

{ #category : #'*Sandblocks-JavascriptReact' }
MMBrowserMorph >> moveCursorTo: aNumber [

	
]

{ #category : #'*Sandblocks-JavascriptReact' }
MMBrowserMorph class >> reactOpenOn: aUrl [

	^ self new
		viewportSize: 300 @ 300;
		performedAutoResizing: false;
		connect: aUrl;
		changed;
		yourself
]

{ #category : #'*Sandblocks-JavascriptReact' }
MMBrowserMorph >> stopEditing [

	
]

{ #category : #'*Sandblocks-JavascriptReact-override' }
MMBrowserMorph >> updateImage: payload [

	| form |
	form := self class parseImage: payload into: self image.
	form extent > viewportSize ifTrue: ["We need to crop the incoming image if we don't run Chrome in headless mode
		or if we just resized the window and Chrome still sends us a bigger image than now requested."
	form := form contentsOfArea: (0 @ 0 extent: viewportSize)].
	
	self image: form.
	self flag: #TODO.
	"The object does not understand checkResize. Only unless the React Tree Sitter projekt is loaded. Thus this might lead to errors and performedAutoResizing needs to be turned of all the time."
	self performedAutoResizing ifFalse: [
		self addAlarm: #checkResize after: 750.
		self performedAutoResizing: true]
]
