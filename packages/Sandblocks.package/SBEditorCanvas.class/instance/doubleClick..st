as yet unclassified
doubleClick: anEvent

	| closest method |
	closest := self submorphs fold: [:a :b |
		(a center squaredDistanceTo: anEvent position) < (b center squaredDistanceTo: anEvent position) ifTrue: [a] ifFalse: [b]].
	
	self sandblockEditor
		openMethod: (method := SBMethod new
			selector: ''
			arguments: #()
			class: (closest ifNotNil: [:container | container method methodClass] ifNil: [UIManager default chooseClassOrTrait]);
			body: (SBBlockBody new statements: {SBUnknown new})).
	
	method owner center: (self transform globalPointToLocal: anEvent position).
	method hasUnsavedChanges: true.
	self sandblockEditor startInput: method at: 1 replacingContents: true