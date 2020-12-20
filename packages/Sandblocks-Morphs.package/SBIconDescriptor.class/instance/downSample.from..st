as yet unclassified
downSample: aForm from: aFactor

	| x y f |
	x := 0.
	y := 0.
	f := (Form extent: self size asPoint depth: 32) collectColors: [:c | | avgColor |
		avgColor := self averageColorInQuadOfSize: aFactor at: x @ y * aFactor from: aForm.
		x := x + 1.
		x >= self size ifTrue: [y := y + 1. x := 0].
		avgColor].
	"((Array streamContents: [:s | f collectColors: [:c | s nextPut: c]]) allSatisfy: #isTransparent) ifTrue: [self halt]."
	^ f