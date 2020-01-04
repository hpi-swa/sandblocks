as yet unclassified
setEmpty

	editor openMethod: (SBMethod new
		selector: ''
		arguments: #()
		class: UndefinedObject).
	
	editor startInput: editor method at: 1 replacingContents: true