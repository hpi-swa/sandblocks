Class {
	#name : #SBJsComponentScreenshotDude,
	#superclass : #Object,
	#instVars : [
		'notifyGotScreenshotSemaphore',
		'screenshot'
	],
	#category : #'Sandblocks-JavascriptReact'
}

{ #category : #'as yet unclassified' }
SBJsComponentScreenshotDude class >> takeScreenshotOf: aReactComponentString atExample: index withExtent: aPoint [

	| reactComponentAST |
	reactComponentAST := SBJavascript parse: aReactComponentString.
	"index ist currently ignored"
	reactComponentAST allBlocksDo: [:block |
		SBTSQuery new execute: SBJsComponentReplacement replacementQuery against: block capturesDo: [:captures :success |
			(success and: [SBJsComponentReplacement isMatchCorrect: captures]) ifTrue: [ | reactClassName wholeReactClass optionsWithName instance tabId screenshot |
				instance := self new.
				wholeReactClass := (captures at: 'class') sourceString.
				reactClassName := (captures at: 'class_name') contents.
				optionsWithName := 'examples = ', (captures at: 'options') sourceString.
				SBJsComponentReplacement
					generateHtmlFileFor: wholeReactClass
					withClassName: reactClassName
					forOptions: optionsWithName.
				tabId := MMProcessWrapper getOSDependentSingleton
					takeScreenshotAt: SBJsComponentReplacement getTestHTMLFileUrl
					withExtend: aPoint
					for: instance.
				screenshot := instance getScreenshot.
				MMProcessWrapper getOSDependentSingleton closeTab: tabId.
				^ screenshot]]].
	self error: 'Looks like there is no matching examples array in the component.'
]

{ #category : #'as yet unclassified' }
SBJsComponentScreenshotDude class >> test [

	[:sbEditor |
		sbEditor openMorphInView: (ImageMorph new image: (self
			takeScreenshotOf: SBJsComponentReplacement sampleReactClassAsString
			atExample: 0
			withExtent: 300 @ 300))]
]

{ #category : #'as yet unclassified' }
SBJsComponentScreenshotDude class >> test: sbEditor [

	[ | morphy |
		morphy := ImageMorph new.
		sbEditor openMorphInView: morphy.
		morphy image: (self
			takeScreenshotOf: SBJsComponentReplacement sampleReactClassAsString
			atExample: 0
			withExtent: 300 @ 300)] fork
]

{ #category : #'as yet unclassified' }
SBJsComponentScreenshotDude >> getScreenshot [

	self notifyGotScreenshotSemaphore wait.
	^ self screenshot
]

{ #category : #'as yet unclassified' }
SBJsComponentScreenshotDude >> handleFormFields: payload [

	
]

{ #category : #'as yet unclassified' }
SBJsComponentScreenshotDude >> handleGitClone: payload [

	
]

{ #category : #'as yet unclassified' }
SBJsComponentScreenshotDude >> handlePortal: payload [

	
]

{ #category : #'as yet unclassified' }
SBJsComponentScreenshotDude >> handleStructuredData: payload [

	
]

{ #category : #accessing }
SBJsComponentScreenshotDude >> initialize [

	super initialize.
	self notifyGotScreenshotSemaphore: Semaphore new
]

{ #category : #'as yet unclassified' }
SBJsComponentScreenshotDude >> locationUpdated: payload [

	
]

{ #category : #accessing }
SBJsComponentScreenshotDude >> notifyGotScreenshotSemaphore [

	^ notifyGotScreenshotSemaphore
]

{ #category : #accessing }
SBJsComponentScreenshotDude >> notifyGotScreenshotSemaphore: aSemaphore [

	notifyGotScreenshotSemaphore := aSemaphore
]

{ #category : #accessing }
SBJsComponentScreenshotDude >> screenshot [

	^ screenshot
]

{ #category : #accessing }
SBJsComponentScreenshotDude >> screenshot: aForm [

	screenshot := aForm
]

{ #category : #'as yet unclassified' }
SBJsComponentScreenshotDude >> updateImage: payload [

	| form |
	form := MMBrowserMorph parseImage: payload into: (Form extent: 1 @ 1).
	self screenshot: form.
	self notifyGotScreenshotSemaphore signal
]
