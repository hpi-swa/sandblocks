as yet unclassified
inputCommandClass

	^ self resolveBinding ifNotNil: #inputCommandClass ifNil: [SBInputCommand]