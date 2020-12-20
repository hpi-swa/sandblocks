"
The RPControlPanel can be used to manage RPApplications.
Open it from the world menu or with:
	RPControlPanel open
"
Class {
	#name : #RPControlPanel,
	#superclass : #SystemWindow,
	#instVars : [
		'applicationIndex'
	],
	#category : #'RatPack-UI'
}

{ #category : #strings }
RPControlPanel class >> appClassChooserString [

	^ 'Choose the application class' translated
]

{ #category : #strings }
RPControlPanel class >> appNameChooserString [

	^ 'Application Name' translated
]

{ #category : #strings }
RPControlPanel class >> executionModes [

	^ #(deployment debug)
]

{ #category : #constants }
RPControlPanel class >> initialWindowExtent [

	^ 400@300
]

{ #category : #'world menu' }
RPControlPanel class >> menuCommandOn: aBuilder [  
	<worldMenu>
	(aBuilder item: 'RatPack Control Panel')
		parent: #Tools;
		order: 0.5;
		action: [self open]
]

{ #category : #'menu key map' }
RPControlPanel class >> menuKeyMap [
	"Menu with always shown items in the first array, items that apply to a selected service 
	in the second. Items take the form {key . label . help . action}.
	If the label is a symbol, a label selector is assumed and an updating menu item is used.
	If key is nil, there will be no keybinding.
	For string labels, the keybinding is added in parens."
	^ #(
		#(
			$a 'Add' 'Add an application' addApplication
		)
		#(
			$s runningString 'Start/stop the application' toggleRunning
			$e 'Explore' 'Explore the application' exploreObject
			$m 'Set mode' 'Set the application mode' setMode
			$p 'Set port' 'Set the application port' setPort
			$n 'Set name' 'Set the application name' setName
			$x 'Remove' 'Remove the application' removeApplication 
			$r 'Remove all' 'Remove all applications' removeAllApplications
			$n 'Add Model' 'Add a Model to the Application' addModel
			$d 'Remove Model' 'Removes the given Model from the Application' removeModel
			$l 'Toggle Logging' 'En- or Disable the LoggingWindow' toggleLogging 
			$o 'Add Object' 'Add an Object to the Application' addObject
			$i 'Remove Object' 'Removes the Object with the given ID from the Application' removeObject
		)
	)
]

{ #category : #'instance creation' }
RPControlPanel class >> open [

	^ self new
		openInWorld;
		yourself
]

{ #category : #strings }
RPControlPanel class >> portString [

	^ 'Port' translated
]

{ #category : #strings }
RPControlPanel class >> startString [

	^ 'Start' translated, ' (s)'
]

{ #category : #strings }
RPControlPanel class >> stopString [

	^ 'Stop' translated, ' (s)'
]

{ #category : #strings }
RPControlPanel class >> windowTitle [

	^ 'RatPack ', 'Browser' translated, ' ', 'Window' translated
]

{ #category : #actions }
RPControlPanel >> addApplication [

	| labels class port name |
	labels := RPApplication withAllSubclasses collect: [:each | each name].
	class := (self createListOf: labels with: (RPApplication withAllSubclasses)) ifNil: [^ self cancel].

	port := ((self createTextfieldFor: (self class portString)
				  withInitialAnswer: (class defaultPort asString))
				ifEmpty: [^ self cancel]) asInteger.
	name := (self createTextfieldFor: (self class appNameChooserString)
				        withInitialAnswer: (class defaultName asString))
				ifEmpty: [^ self cancel].

	class
		runIn: class defaultMode
		on: port
		named: name.
	self applicationIndex: self applicationList size.
	self change.
]

{ #category : #actions }
RPControlPanel >> addModel [

	| labels model |
	labels := RPModel allSubclasses collect: [:each | each name].
	model := (self createListOf: labels with: RPModel allSubclasses) 
				ifNil: [^ self cancel].
	self selectedApplication registerModel: model.
	self change
]

{ #category : #actions }
RPControlPanel >> addObject [

	| aJsonString labels aRPModelClassName anRPModelClass |
	labels := self selectedApplication modelClasses keys.
	(labels isEmpty)
		ifTrue: [self notify: 'No models registered.']. 
	aRPModelClassName := (self createListOf: labels with: (self selectedApplication modelClasses keys))
						 ifNil: [^ self cancel].
	anRPModelClass := self selectedApplication getRegisteredModel: aRPModelClassName.
	aJsonString := ((self createTextfieldFor: 'Object as JsonString' translated 
						  withInitialAnswer: (anRPModelClass defaultJson))  
						ifEmpty: [^ self cancel]).
	self selectedApplication
		persistObjectBy: (STONJSON fromString: aJsonString) 
		from: anRPModelClass.
	self change
	
]

{ #category : #accessing }
RPControlPanel >> applicationIndex [
	"Answer the value of applicationIndex"

	^ applicationIndex
]

{ #category : #accessing }
RPControlPanel >> applicationIndex: anObject [
	"Set the value of applicationIndex"

	applicationIndex := anObject.
	self change.
]

{ #category : #accessing }
RPControlPanel >> applicationInspect [

	| set |
	set := Set new.
	self selectedApplication ifNil: [^ ''].
	self selectedApplication routes values do: [:each | each do: [:value | set add: value key]].
	^ 'routes: ', (set asArray joinSeparatedBy: '   ') printString, String cr,
		'mode: ', self selectedApplication mode printString, String cr,
			'models: ', (self selectedApplication modelClasses keys asArray joinSeparatedBy: '   ') printString, String cr
]

{ #category : #accessing }
RPControlPanel >> applicationList [

	^ RPApplication services asArray sort: [:a :b | a name < b name]
]

{ #category : #menu }
RPControlPanel >> applicationMenu: aMenu shifted: shift [

	aMenu setTarget: self.
	self fillApplicationMenu: aMenu from: self class menuKeyMap first.
	self selectedApplication ifNotNil: [
		aMenu addLine.
		self fillApplicationMenu: aMenu from: self class menuKeyMap second].
	^ aMenu
]

{ #category : #initialization }
RPControlPanel >> buildApplicationDetail [

	self
		addMorph: (PluggableTextMorph new
						on: self 
						text: #applicationInspect
						accept: nil
						readSelection: nil
						menu: nil;
						width: self width;
						height: self height / 2;
						topLeft: self height / 2 + self topLeft)
		fullFrame: (LayoutFrame fractions: (0@0.5 corner: 1@1)).

]

{ #category : #initialization }
RPControlPanel >> buildApplicationList [

	self
		addMorph: (PluggableListMorph new
						on: self
						list: #applicationList
						selected: #applicationIndex
						changeSelected: #applicationIndex:
						menu: #applicationMenu:shifted:
						keystroke: #handleShortcut:;
						width: self width;
						height: self height / 2;
						topLeft: self topLeft)
		fullFrame: (LayoutFrame fractions: (0@0 corner: 1@0.49)).
]

{ #category : #helpers }
RPControlPanel >> cancel [

	^ self
]

{ #category : #'change reporting' }
RPControlPanel >> change [

	self
		changed: #applicationList;
		changed: #applicationIndex;
		changed: #applicationInspect.
]

{ #category : #helpers }
RPControlPanel >> createListOf: labels with: values [

	^ UIManager default
				chooseFrom: labels
				values: values
				lines: #()
				title: 'Choose'
]

{ #category : #helpers }
RPControlPanel >> createTextfieldFor: name withInitialAnswer: aString [ 

	^UIManager default
					request: name
					initialAnswer: aString
]

{ #category : #actions }
RPControlPanel >> exploreObject [

	self selectedApplication explore.
]

{ #category : #menu }
RPControlPanel >> fillApplicationMenu: aMenu from: aSpecificationList [

	aSpecificationList groupsOf: 4 atATimeDo: [:key :lbl :help :action |
		lbl isSymbol
			ifFalse: [aMenu add: (key ifNil: [lbl] ifNotNil: [lbl, ' (', key asString, ')']) action: action]
			ifTrue: [aMenu addUpdating: lbl action: action].
		 aMenu balloonTextForLastItem: help].

]

{ #category : #'event handling' }
RPControlPanel >> handleShortcut: aChar [
	| keyMap |
	keyMap := Dictionary new.
	self class menuKeyMap first groupsOf: 4 atATimeDo: [:key :label :help :action |
		keyMap at: key put: action].
	self selectedApplication ifNotNil: [
		self class menuKeyMap second groupsOf: 4 atATimeDo: [:key :label :help :action |
			keyMap at: key put: action]].
	self perform: (keyMap at: aChar ifAbsent: [#yourself]).
]

{ #category : #'open/close' }
RPControlPanel >> initialExtent [

	^ self class initialWindowExtent
]

{ #category : #initialization }
RPControlPanel >> initialize [

	super initialize.
	self
		setLabel: self class windowTitle;
		applicationIndex: 0;
		layoutPolicy: ProportionalLayout new;
		buildApplicationList;
		buildApplicationDetail.
]

{ #category : #actions }
RPControlPanel >> removeAllApplications [

	self applicationList do: [ :each  |
		RPApplication removeService: each stop;
										      yourself.
		self change.]
]

{ #category : #actions }
RPControlPanel >> removeApplication [

	RPApplication removeService: self selectedApplication
										stop;
										yourself.
	self change.
]

{ #category : #actions }
RPControlPanel >> removeModel [

	| aRPModelClass labels |
	labels := self selectedApplication modelClasses keys.
	aRPModelClass := (self createListOf: labels with: (self selectedApplication modelClasses keys)) 
						ifNil: [^ self cancel].
	self selectedApplication removeModel: (Smalltalk classNamed: aRPModelClass).
	self change
	
]

{ #category : #actions }
RPControlPanel >> removeObject [

	| aRPModelClass id labels numbers |
	labels := self selectedApplication modelClasses keys.
	(labels isEmpty)
		ifTrue: [self notify: 'No models registered!']. 
	aRPModelClass := (self createListOf: labels with: self selectedApplication modelClasses keys) 
						ifNil: [^ self cancel].
	numbers := (self selectedApplication database modelDictionary at: aRPModelClass) keys.
	(numbers isEmpty)
		ifTrue: [self notify: 'No objects available.'].

	id := (self createListOf: numbers 
			    with: (self selectedApplication database modelDictionary at: aRPModelClass) keys) 
			ifNil: [^ self cancel].
	self selectedApplication writeRemovedObjectForDelete: aRPModelClass asSymbol id: id .
	self change
	
]

{ #category : #accessing }
RPControlPanel >> runningString [

	^ self selectedApplication
		ifNil: ['']
		ifNotNilDo: [:app |
			app isRunning ifTrue: [self class stopString] ifFalse: [self class startString]]
]

{ #category : #accessing }
RPControlPanel >> selectedApplication [

	^ self applicationList at: self applicationIndex ifAbsent: []
]

{ #category : #actions }
RPControlPanel >> setMode [

	| modes |
	modes := self class executionModes.
	self selectedApplication
		mode: ((self createListOf: modes with: modes) ifNil: [^ self cancel]).
	self change
]

{ #category : #actions }
RPControlPanel >> setName [

	self selectedApplication
		name: ((self createTextfieldFor: (self class appNameChooserString)
					 withInitialAnswer: (self selectedApplication name))
				ifEmpty: [^ self cancel]).
	self change
]

{ #category : #actions }
RPControlPanel >> setPort [

	self selectedApplication
		portNumber: ((self createTextfieldFor: (self class portString) 
						     withInitialAnswer: (self selectedApplication portNumber asString))
							ifEmpty: [^ self cancel]) asInteger.
	self change
]

{ #category : #actions }
RPControlPanel >> toggleLogging [

	self selectedApplication logWindow loggingIsEnabled 
		ifTrue: [self selectedApplication disableLogging ]
		ifFalse: [self selectedApplication enableLogging ].
	self change.

]

{ #category : #actions }
RPControlPanel >> toggleRunning [

	self selectedApplication isRunning
		ifTrue: [self selectedApplication stop]
		ifFalse: [self selectedApplication start].
	self change.
]
