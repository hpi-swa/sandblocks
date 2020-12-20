as yet unclassified
fitsDocument: command at: aState limit: maxRight

	| state |
	^ command type caseOf: {
		[#group] -> [
			state := aState.
			command data do: [:el |
				state := self fitsDocument: el at: state limit: maxRight].
			state].
		[#indent] -> [self fitsDocument: (SBAlgebraCommand group data: command data) at: aState limit: maxRight].
		[#container] -> [ | inset |
			inset := command morph layoutInset asEdgeInsets.
			state := self
				fitsDocument: (SBAlgebraCommand group data: command data)
				at: (((aState offset: aState offset + inset topLeft lineHeight: inset top) startX: aState offset x + inset left) containerWidth: 0)
				limit: maxRight.
			state := (state offset: (state offset + (inset right @ 0)) lineHeight: state lineHeight + inset bottom) containerWidth: state containerWidth + inset right.
			((state
				offset: (state offset x max: state containerWidth) @ state offset y
				lineHeight: (state lineHeight max: aState lineHeight))
				startX: aState startX)
				containerWidth: (aState containerWidth max: state containerWidth) + inset right].
		[#hardLine] -> [aState offset: aState startX @ (aState offset y + aState lineHeight) lineHeight: 0].
		[#softLine] -> [aState].
		[#softLineOrGap] -> [aState offset: aState offset + (self gap @ 0)].
		[#gap] -> [aState offset: aState offset + (self gap @ 0)].
		[#morph] -> [ | extent |
			extent := command data minExtent.
			aState
				offset: aState offset + (extent x @ 0)
				lineHeight: (aState lineHeight max: extent y)].
		[#noop] -> [aState].
	}