as yet unclassified
doubleClick: anEvent

	| closest method point |
	point := self transform globalPointToLocal: anEvent position.
	closest := self submorphs fold: [:a :b |
		(a center squaredDistanceTo: point) < (b center squaredDistanceTo: point) ifTrue: [a] ifFalse: [b]].
	
	self sandblockEditor
		openMorphInView: (method := SBMethod new
			selector: ''
			arguments: #()
			class: (closest ifNotNil: [:container | container relatedClass] ifNil: [UIManager default chooseClassOrTrait]);
			body: (SBBlockBody new statements: {SBUnknown new})).
	
	method center: point.
	method hasUnsavedChanges: true.
	self sandblockEditor startInput: method at: 1 replacingContents: true