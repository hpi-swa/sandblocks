as yet unclassified
setEmpty

	editor method: (SBMethod new
		selector: ''
		arguments: #()
		class: UndefinedObject).
	
	editor startInput: editor method at: 1 replacingContents: true