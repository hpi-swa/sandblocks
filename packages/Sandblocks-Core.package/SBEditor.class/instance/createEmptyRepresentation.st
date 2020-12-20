actions
createEmptyRepresentation
	<action>

	| representation |
	representation := SBRepresentationEditor new class: nil.
	self openMorphInView: representation.
	self startInput: representation childSandblocks first at: 1 replacingContents: false