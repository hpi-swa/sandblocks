as yet unclassified
target: aBlock

	| rightShortcuts |
	target := aBlock.
	self openInWorld.
	self position: 0 @ 0.
	self addMorphBack: ((SBHelpShortcut new shortcuts: {({$o asSandblockShortcut. 'Statement below'}). ({$p asSandblockShortcut. 'Paste below'})}) below: aBlock).
	self addMorphBack: ((SBHelpShortcut new shortcuts: {({$O asSandblockShortcut. 'Statement above'}). ({$P asSandblockShortcut. 'Paste above'})}) above: aBlock).
	rightShortcuts := OrderedCollection new.
	(self canAdd: aBlock) ifNotNil: [
		rightShortcuts add: {$. asSandblockShortcut. 'Add element'}].
	(self canInsertAfter: aBlock) ifNotNil: [
		rightShortcuts add: {$+ asSandblockShortcut. 'Insert element after'}].
	(self canInsertBefore: aBlock) ifNotNil: [
		self addMorphBack: ((SBHelpShortcut new shortcuts: {({$* asSandblockShortcut. 'Insert element before'})}) left: aBlock)].
	rightShortcuts ifNotEmpty: [
		self addMorphBack: ((SBHelpShortcut new shortcuts: rightShortcuts) right: aBlock)].
	self addMorphBack: ((SBHelpShortcut new shortcuts: {({$g asSandblockShortcut. 'Select artefact'})}) above: aBlock containingArtefact).
	self addMorphBack: ((SBHelpShortcut new shortcuts: {({$G asSandblockShortcut. 'Select last child'})}) below: aBlock containingArtefact lastDeepChild)