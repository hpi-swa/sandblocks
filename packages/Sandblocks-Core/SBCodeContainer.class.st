"
A SBCodeContainer is an abstraction to support bundling a number of methods or other code containers within a morph.
"
Class {
	#name : #SBCodeContainer,
	#superclass : #SBBlock,
	#instVars : [
		'lastDragPosition',
		'velocity'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #testing }
SBCodeContainer >> codeContainer [

	^ self
]

{ #category : #accessing }
SBCodeContainer >> color [

	^ Color white
]

{ #category : #accessing }
SBCodeContainer >> containingArtefact [

	^ nil
]

{ #category : #callbacks }
SBCodeContainer >> deleteCommandFor: aBlock [

	^ SBCombinedCommand newWith: {
		SBDeleteCommand newNonEdit target: self.
		"(SBDeleteMethodCommand newFor: SBNullSavable new) method: self method"
	}
]

{ #category : #examples }
SBCodeContainer >> exampleSameSize [
	SBMorphExample
		setUp: [SBEditor new
				openMorphInView: (SBCodeContainer new
						addMorph: (Morph new color: Color red));
				
				openMorphInView: (SBCodeContainer new
						addMorph: (Morph new color: Color green));
				 yourself]
		cases: {SBMorphExampleCase
				name: 'a'
				caseBlock: [:c | ]}
		extent: 619 @ 574
]

{ #category : #'event handling' }
SBCodeContainer >> handlesMouseMove: anEvent [

	^ true
]

{ #category : #initialization }
SBCodeContainer >> initialize [

	super initialize.
	
	velocity := 0 @ 0.
	
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #testing }
SBCodeContainer >> isCodeContainer [

	^ true
]

{ #category : #testing }
SBCodeContainer >> isDragging [

	^ lastDragPosition notNil
]

{ #category : #'event handling' }
SBCodeContainer >> mouseMove: anEvent [

	lastDragPosition ifNotNil: [
		self position: self position + (anEvent position - lastDragPosition).
		lastDragPosition := anEvent position]
]

{ #category : #'event handling' }
SBCodeContainer >> mouseUp: anEvent [

	lastDragPosition ifNotNil: [
		anEvent hand releaseMouseFocus: self.
		lastDragPosition := nil]
]

{ #category : #initialization }
SBCodeContainer >> openNear: aBlock [

	aBlock sandblockEditor openMorphInView: self.
	self position: aBlock containingArtefact right + (5 * self scalingFactor) @ self top.
	self select
]

{ #category : #accessing }
SBCodeContainer >> preventOcclusion [

	^ true
]

{ #category : #'event handling' }
SBCodeContainer >> startDrag: anEvent [

	lastDragPosition := anEvent position
]

{ #category : #'stepping and presenter' }
SBCodeContainer >> step [

	self isDragging ifTrue: [^ self].
	self owner submorphsDo: [:morph | 
		(morph preventOcclusion and: [morph ~= self and: [self bounds intersects: morph bounds]])
			ifTrue: [ | speed intersection direction maxSpeed |
				intersection := self bounds intersect: morph bounds.
				speed := intersection area.
				direction := Point fromSide: (morph bounds sideNearestTo: intersection center).
				velocity := velocity + ((direction * 0.005) * speed).
				maxSpeed := 45.
				velocity := (velocity x clampLow: maxSpeed negated high: maxSpeed) @ (velocity y clampLow: maxSpeed negated high: maxSpeed)]].
	(velocity closeTo: 0 @ 0)
		ifTrue: [velocity := 0 @ 0]
		ifFalse: [
			velocity := velocity * 0.5.
			self position: self position + velocity]
]

{ #category : #'stepping and presenter' }
SBCodeContainer >> stepTime [

	^ 1
]
