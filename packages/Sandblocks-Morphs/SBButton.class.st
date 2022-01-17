Class {
	#name : #SBButton,
	#superclass : #Morph,
	#instVars : [
		'action',
		'hovered',
		'pressed',
		'active'
	],
	#category : #'Sandblocks-Morphs'
}

{ #category : #accessing }
SBButton >> active [

	^ active ifNil: [false]
]

{ #category : #accessing }
SBButton >> active: aBoolean [
	" show the button as activated "

	active := aBoolean.
	self changed
]

{ #category : #accessing }
SBButton >> borderStyle [

	^ BorderStyle width: 1 color: (self colorPolicy ifNotNil: [:c | c borderColorForButton: self] ifNil: [Color gray alpha: 0.3])
]

{ #category : #'debug and other' }
SBButton >> buildDebugMenu: aHandMorph [

	^ (super buildDebugMenu: aHandMorph)
		addLine;
		add: 'debug action invocation' translated
			target: self
			action: #debugAction;
		yourself
]

{ #category : #'event handling' }
SBButton >> clicked [

	action value.
	self mouseEntered
]

{ #category : #accessing }
SBButton >> color [

	| base |
	SBToggledCode comment: '' active: 1 do: {
		[
			base := self containingSandblock
				ifNotNil: #drawnColor
				ifNil: [Color r: 1 g: 1 b: 1]].
		[base := self colorPolicy colorForButton: self]}.
	
	self active ifTrue: [base := base darker].
	
	self pressed ifTrue: [^ base darker darker].
	self hovered ifTrue: [^ base darker].
	^ base
]

{ #category : #accessing }
SBButton >> colorPolicy [

	^ self containingSandblock ifNotNil: [:b | b colorPolicy]
]

{ #category : #'debug and other' }
SBButton >> debugAction [

	(Process
		forBlock: [self doButtonAction]
		runUntil: [:context | context closure = action or: [context receiver = action]]) debugWithTitle: ('Debug button action "{1}"' translated format: {self label})
]

{ #category : #button }
SBButton >> doButtonAction [

	^ self clicked
]

{ #category : #'as yet unclassified' }
SBButton >> example [

	SBMorphExample
		setUp: [SBButton new]
		cases: {
			(SBMorphExampleCase
				name: 'example 1'
				caseBlock: [:m |
					m label: 'Hello' shortcut: $p command do: [nil].
					m owner addMorphBack: (SBButton new icon: (SBIcon iconUndo color: Color black) shortcut: $p asSandblockShortcut do: [nil])])
		}
		extent: 300 @ 300
]

{ #category : #'visual properties' }
SBButton >> fillStyle [

	^ self color
]

{ #category : #'event handling' }
SBButton >> handlesMouseDown: anEvent [

	^ anEvent redButtonPressed
]

{ #category : #accessing }
SBButton >> hovered [

	^ hovered ifNil: [false]
]

{ #category : #accessing }
SBButton >> hovered: aBoolean [

	hovered := aBoolean.
	self changed
]

{ #category : #initialization }
SBButton >> icon: anIconMorph label: aString do: aBlock [

	self example: [SBButton new] args: [{SBIcon iconUndo. $u asSandblockShortcut. [nil]}] label: 'icon'.
	
	self widget: anIconMorph shortcut: nil do: aBlock.
	
	self addMorphBack: (SBStringMorph new
		contents: aString;
		emphasis: TextEmphasis bold emphasisCode)
]

{ #category : #initialization }
SBButton >> icon: anIconMorph shortcut: aShortcut do: aBlock [

	self
		example: [SBButton new]
		args: [{SBIcon iconUndo. $u asSandblockShortcut. [nil]}]
		label: 'icon'.
	self widget: anIconMorph shortcut: aShortcut do: aBlock
]

{ #category : #initialization }
SBButton >> initialize [

	super initialize.
	
	hovered := false.
	
	self
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		listDirection: #leftToRight;
		cellGap: 8;
		layoutInset: 8 @ 4;
		cornerStyle: #rounded;
		on: #mouseEnter send: #mouseEntered to: self;
		on: #mouseLeave send: #mouseLeft to: self;
		on: #mouseDown send: #mouseDown to: self;
		on: #mouseUp send: #mouseUp to: self;
		on: #mouseLeaveDragging send: #mouseLeft to: self;
		on: #click send: #clicked to: self
]

{ #category : #'meta-actions' }
SBButton >> invokeMetaMenu: evt [

	
]

{ #category : #accessing }
SBButton >> label [

	^ self submorphs
		detect: [:m | m isKindOf: SBStringMorph]
		ifFound: [:m | m contents]
		ifNone: [self name]
]

{ #category : #accessing }
SBButton >> label: aString [

	(self submorphs detect: [:m | m isKindOf: SBStringMorph] ifNone: [
		^ self addMorphFront: (SBStringMorph new
			contents: aString;
			emphasis: TextEmphasis bold emphasisCode)]) contents: aString
]

{ #category : #initialization }
SBButton >> label: aString shortcut: aShortcut do: aBlock [

	self example: [SBButton new] args: [{'hello'. $p command. [nil]}] label: 'label'.
	self
		widget: (SBStringMorph new
			contents: aString;
			emphasis: TextEmphasis bold emphasisCode)
		shortcut: aShortcut
		do: aBlock
]

{ #category : #'event handling' }
SBButton >> mouseDown [
	
	self pressed: true
]

{ #category : #'event handling' }
SBButton >> mouseEntered [

	self hovered: true
]

{ #category : #'event handling' }
SBButton >> mouseLeft [

	self hovered: false.
	self pressed: false
]

{ #category : #'event handling' }
SBButton >> mouseUp [

	self pressed: false
]

{ #category : #accessing }
SBButton >> onClick: aBlock [

	action := aBlock
]

{ #category : #accessing }
SBButton >> pressed [

	^ pressed ifNil: [false]
]

{ #category : #accessing }
SBButton >> pressed: aBoolean [
	" the button is currently being held by the pressed mouse cursor "

	pressed := aBoolean.
	self changed
]

{ #category : #initialization }
SBButton >> widget: aMorph shortcut: aShortcut do: aBlock [

	action := aBlock.
	self addMorphBack: aMorph.
	aShortcut ifNotNil: [
		self addMorphBack: (SBStringMorph new
			contents: (aShortcut isCollection
				ifTrue: [aShortcut anyOne displayString]
				ifFalse: [aShortcut displayString]);
			opacity: 0.7)]
]
