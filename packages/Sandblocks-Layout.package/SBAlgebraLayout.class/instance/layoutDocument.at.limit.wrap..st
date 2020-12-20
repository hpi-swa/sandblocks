as yet unclassified
layoutDocument: command at: aState limit: maxRight wrap: aWrapBoolean

	| state |
	^ command type caseOf: {
		[#group] -> [ | fits |
			state := aState.
			fits := (self fitsDocument: command at: aState limit: maxRight) offset x <= maxRight.
			command data do: [:el |
				state := self layoutDocument: el at: state limit: maxRight wrap: fits not].
			state].
		[#indent] -> [
			state := aState startX: aState startX + self indent.
			state := self layoutDocument: (SBAlgebraCommand group data: command data) at: state limit: maxRight wrap: aWrapBoolean.
			state startX: state startX - self indent].
		[#container] -> [ | inset |
			inset := command morph layoutInset asEdgeInsets.
			state := self
				layoutDocument: (SBAlgebraCommand group data: command data)
				at: (((aState offset: aState offset + inset topLeft lineHeight: inset top) startX: aState offset x + inset left) containerWidth: 0)
				limit: maxRight
				wrap: aWrapBoolean.
			state := (state offset: (state offset + (inset right @ 0)) lineHeight: state lineHeight + inset bottom) containerWidth: state containerWidth + inset right.
			
			measure ifFalse: [command morph layoutInBounds: (aState offset extent: ((state extentFrom: aState) max: 0 @ command morph minimumHeight))].
			((state
				offset: (state offset x max: state containerWidth) @ state offset y
				lineHeight: ((state lineHeight max: aState lineHeight) max: command morph minimumHeight))
				startX: aState startX)
				containerWidth: (aState containerWidth max: state containerWidth) + inset right].
		[#hardLine] -> [
			(aState offset: aState startX @ (aState offset y + aState lineHeight + (command withGap ifTrue: [self gap] ifFalse: [0])) lineHeight: 0) containerWidth: (aState containerWidth max: aState offset x)].
		[#softLine] -> [
			aWrapBoolean
				ifTrue: [self layoutDocument: (SBAlgebraCommand hardLine withGap: command withGap) at: aState limit: maxRight wrap: aWrapBoolean]
				ifFalse: [aState]].
		[#softLineOrGap] -> [
			aWrapBoolean
				ifTrue: [self layoutDocument: (SBAlgebraCommand hardLine withGap: command withGap) at: aState limit: maxRight wrap: aWrapBoolean]
				ifFalse: [aState offset: aState offset + (self gap @ 0)]].
		[#gap] -> [aState offset: aState offset + (self gap @ 0)].
		[#morph] -> [ | extent |
			extent := command data minExtent.
			measure ifFalse: [command data bounds: (aState offset extent: extent)].
			aState
				offset: aState offset + (extent x @ 0)
				lineHeight: (aState lineHeight max: extent y)].
		[#noop] -> [aState].
	}