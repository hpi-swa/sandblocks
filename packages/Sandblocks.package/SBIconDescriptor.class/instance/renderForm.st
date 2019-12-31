as yet unclassified
renderForm

	| rect form |
	rect := 0 @ 0 extent: self size asPoint * ECSIcon supersamplingFactor.
	self svg bounds: rect.
	self svg allMorphsDo: [:morph | morph style at: 'fill' put: self color].
	
	form := self svg imageFormForRectangle: rect.
	^ ECSIcon supersamplingFactor > 1
		ifTrue: [form scaledToSize: self size asPoint smoothing: 16]
		ifFalse: [form]