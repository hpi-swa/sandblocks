comparing
= anIconDescriptor

	^ self svg == anIconDescriptor svg and:
	[self size = anIconDescriptor size and:
	[self color = anIconDescriptor color]]