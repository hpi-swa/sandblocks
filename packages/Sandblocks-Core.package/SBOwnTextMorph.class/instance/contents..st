as yet unclassified
contents: aString

	contents ~= aString ifTrue: [
		contents := aString.
		cursor := cursor min: aString size + 1.
	
		self
			changed;
			layoutChanged;
			triggerEvent: #contentsChanged]