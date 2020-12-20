Class {
	#name : #SBButton,
	#superclass : #Morph,
	#instVars : [
		'action'
	],
	#category : #'Sandblocks-Morphs'
}

{ #category : #'as yet unclassified' }
SBButton >> clicked [

	action value.
	self mouseEntered
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

{ #category : #'as yet unclassified' }
SBButton >> icon: anIconMorph shortcut: aShortcut do: aBlock [

	SBExample self: [SBButton new] args: [{SBIcon iconUndo. $u asSandblockShortcut. [nil]}] label: 'icon'.
	self widget: (anIconMorph
		color: Color black;
		yourself) shortcut: aShortcut do: aBlock
]

{ #category : #'as yet unclassified' }
SBButton >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		borderStyle: (BorderStyle width: 1 color: Color veryLightGray);
		listDirection: #leftToRight;
		cellGap: 8 withScalingFactor;
		layoutInset: (8 @ 4) withScalingFactor;
		color: Color white;
		cornerStyle: #rounded;
		on: #mouseEnter send: #mouseEntered to: self;
		on: #mouseLeave send: #mouseLeft to: self;
		on: #mouseDown send: #mousePressed to: self;
		on: #mouseLeaveDragging send: #mouseLeft to: self;
		on: #click send: #clicked to: self
]

{ #category : #nil }
SBButton >> label: aString [

	self lastSubmorph contents: aString.
]

{ #category : #'as yet unclassified' }
SBButton >> label: aString shortcut: aShortcut do: aBlock [

	SBExample self: [SBButton new] args: [{'hello'. $p command. [nil]}] label: 'label'.
	self
		widget: (StringMorph new
			contents: aString;
			emphasis: TextEmphasis bold emphasisCode)
		shortcut: aShortcut
		do: aBlock
]

{ #category : #'as yet unclassified' }
SBButton >> mouseEntered [

	self color: (Color r: 0.9 g: 0.9 b: 0.9)
]

{ #category : #'as yet unclassified' }
SBButton >> mouseLeft [

	self color: Color white
]

{ #category : #'as yet unclassified' }
SBButton >> mousePressed [

	self color: (Color r: 0.8 g: 0.8 b: 0.8)
]

{ #category : #'as yet unclassified' }
SBButton >> widget: aMorph shortcut: aShortcut do: aBlock [

	action := aBlock.
	self addMorphBack: aMorph.
	aShortcut ifNotNil: [
		self addMorphBack: (StringMorph new
			contents: aShortcut displayString;
			color: Color gray)]
]
