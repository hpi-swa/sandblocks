as yet unclassified
reportValue: aCanvas

	self image: ((aCanvas form width > 100 or: [aCanvas form height > 100])
		ifTrue: [aCanvas form scaledIntoFormOfSize: 100 asPoint]
	 	ifFalse: [aCanvas form copy])