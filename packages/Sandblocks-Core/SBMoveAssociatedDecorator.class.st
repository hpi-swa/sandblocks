"
A decorator that allows moving its attached morph. If the morph is moved over a different artefact, it informs the user that dropping the morph here will move it to that artefact. Best used with blocks that don't #preventOcclusion.
"
Class {
	#name : #SBMoveAssociatedDecorator,
	#superclass : #SBMoveDecorator,
	#instVars : [
		'leaveHint',
		'hintBlock'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBMoveAssociatedDecorator >> hintBlock: aBlock [

	hintBlock := aBlock
]

{ #category : #'as yet unclassified' }
SBMoveAssociatedDecorator >> mouseMove: event [

	super mouseMove: event.
	self isDragging ifTrue: [
		self
			newArtefactAt: event position
			do: [:n | self showLeaveHint: true for: n]
			ifNone: [self showLeaveHint: false for: nil]]
]

{ #category : #'as yet unclassified' }
SBMoveAssociatedDecorator >> mouseUp: event [

	super mouseUp: event.
	
	self
		newArtefactAt: event position
		do: [:newArtefact |
			self morph sandblockEditor do: (SBMoveCommand new
				morph: self morph;
				container: newArtefact;
				index: 1)]
		ifNone: [].
	self showLeaveHint: false for: nil
]

{ #category : #'as yet unclassified' }
SBMoveAssociatedDecorator >> newArtefactAt: aPoint do: aBlock ifNone: anotherBlock [

	| container |
	container := self morph outerMostArtefact.
	
	" find the first artefact under the cursor and see if it's different to our current "
	container ~= self ifTrue: [
		(container morphsAt: aPoint)
			detect: [:m | m isSandblock and: [m isArtefact and: [m ~= self morph]]]
			ifFound: [:m |
				m ~= self morph outerArtefact
					ifTrue: [^ aBlock value: m]
					ifFalse: [^ anotherBlock value]]].
	
	^ anotherBlock value
]

{ #category : #'as yet unclassified' }
SBMoveAssociatedDecorator >> showLeaveHint: aBoolean for: anArtefact [

	aBoolean
		ifTrue: [
			leaveHint ifNil: [
				leaveHint := SBStringMorph new contents: (hintBlock ifNil: ['Move to this block'] ifNotNil: [hintBlock value: anArtefact]).
				self morph sandblockEditor openMorph: leaveHint].
			leaveHint bottomLeft: self morph topLeft]
		ifFalse: [
			leaveHint ifNotNil: #delete.
			leaveHint := nil]
]
