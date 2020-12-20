actions
createEmptyMethod
	<action>

	| method |
	self openMorphInView: (method := SBMethod new
		selector: ''
		arguments: #()
		class: ((self selectedArtefact ifNotNil: [:container | container relatedClass]) ifNil: [UIManager default chooseClassOrTrait]);
		body: (SBBlockBody new statements: {SBUnknown new})).
	self startInput: method at: 1 replacingContents: true