replacing
examplesFor: aDictWithBlockCaptures

	(aDictWithBlockCaptures at: 'example_array') access children withIndexDo: [:example :index | | filePath |
		filePath := self
			filePathForComponentName: (aDictWithBlockCaptures at: 'class_name') contents
			andIndex: index.
		self examplesRow addMorphBack: (self newExample: example withCaptures: aDictWithBlockCaptures filePath: filePath)]