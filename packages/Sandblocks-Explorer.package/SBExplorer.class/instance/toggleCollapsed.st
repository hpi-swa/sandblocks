as yet unclassified
toggleCollapsed
	<action>

	| caption |
	caption := self firstSubmorph.
	self isCollapsed not
		ifTrue: [
			label clearEmphasis.
			self
				removeAllMorphs;
				addMorphBack: caption]
		ifFalse: [
			label bold.
			inspector streamFieldsOn: (SBImmediateStream with: [:field | 
				(#(#all #self) includes: field type) ifFalse: [
					self addMorphBack: (SBRow new
						cellGap: 4 withScalingFactor;
						layoutInset: (SBEdgeInsets left: 12 withScalingFactor right: 0 top: 0 bottom: 0);
						addMorphBack: (SBStringMorph new contents: field name asString);
						addMorphBack: (SBExplorer on: ([field getValueFor: inspector] on: Error do: [nil]) field: (field inspector: inspector)))]])]