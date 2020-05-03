Class {
	#name : #SBOverlay,
	#superclass : #Morph,
	#instVars : [
		'activeMorph',
		'editor'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBOverlay >> deadzoneDistance [

	^ 30 * self scalingFactor
]

{ #category : #'as yet unclassified' }
SBOverlay >> initialize [

	super initialize.
	
	self
		extent: 1 @ 1;
		color: Color transparent;
		addMorphBack: (SBOverlayOption new
			contents: 'Navigation';
			suboptions: {
				SBOverlayOption new
					command: #swapLeft;
					contents: 'Swap left';
					place: self optionDistance @ 0.
				SBOverlayOption new
					command: #swapRight;
					contents: 'Swap right';
					place: self optionDistance negated @ 0.
			};
			center: self center; top: self optionDistance);
		addMorphBack: (SBOverlayOption new
			contents: 'Modify';
			suboptions: {
				SBOverlayOption new
					contents: 'Delete';
					command: #deleteSelection;
					place: self optionDistance @ -80.
				SBOverlayOption new
					command: #startInputAtStart;
					contents: 'Insert';
					place: self optionDistance @ 0.
				SBOverlayOption new
					contents: 'Substitute';
					command: #startInputSubstituting;
					place: self optionDistance @ 80.
			};
			center: self center; left: self optionDistance);
		addMorphBack: (SBOverlayOption new
			contents: 'Refactor';
			suboptions: {
				SBOverlayOption new
					contents: 'Extract variable';
					command: #extractVariable;
					place: self optionDistance negated @ -50.
				SBOverlayOption new
					contents: 'Extract method';
					command: #extractMethod;
					place: self optionDistance negated @ 50
			};
			center: self center; right: self optionDistance negated);
		addMorphBack: (SBOverlayOption new
			contents: 'Replace';
			suboptions: {
				SBOverlayOption new
					contents: 'Swap left';
					place: self optionDistance @ 0.
				SBOverlayOption new
					contents: 'Swap right';
					place: self optionDistance negated @ 0
			};
			center: self center; bottom: self optionDistance negated)
]

{ #category : #'as yet unclassified' }
SBOverlay >> mouseMove: anEvent [

	| closestMorph |
	(self center squaredDistanceTo: anEvent position) < (self deadzoneDistance ** 2) ifTrue: [
		activeMorph ifNotNil: [activeMorph active: false].
		activeMorph := nil.
		^ self].
	
	closestMorph := self submorphs
		inject: self firstSubmorph
		into: [:closest :morph | 
			(closest center squaredDistanceTo: anEvent position) > (morph center squaredDistanceTo: anEvent position)
				ifTrue: [morph]
				ifFalse: [closest]].
	
	activeMorph := closestMorph focusFrom: activeMorph
]

{ #category : #'as yet unclassified' }
SBOverlay >> mouseUp: anEvent [

	self delete.
	
	(activeMorph notNil and: [activeMorph command notNil]) ifTrue: [self sandblockEditor perform: activeMorph command]
]

{ #category : #'as yet unclassified' }
SBOverlay >> optionDistance [

	^ 80 * self scalingFactor
]

{ #category : #'as yet unclassified' }
SBOverlay >> sandblockEditor [

	^ editor
]

{ #category : #'as yet unclassified' }
SBOverlay >> sandblockEditor: anEditor [

	editor := anEditor
]
