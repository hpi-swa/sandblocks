as yet unclassified
setSelector: aString arguments: aCollection

	editor openMorphInView: (SBMethod new
		selector: aString
		arguments: aCollection veryDeepCopy
		class: UndefinedObject).
	
	editor startInput: editor method at: 1 replacingContents: false