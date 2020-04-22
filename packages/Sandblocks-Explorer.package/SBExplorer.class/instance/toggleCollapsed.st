as yet unclassified
toggleCollapsed

	| caption |
	caption := self firstSubmorph.
	self submorphCount > 1
		ifTrue: [
			caption lastSubmorph clearEmphasis.
			self
				removeAllMorphs;
				addMorphBack: caption]
		ifFalse: [
			caption lastSubmorph bold.
			inspector streamFieldsOn: (SBImmediateStream with: [:field |
				(#(all self) includes: field type) ifFalse: [
					self addMorphBack: (SBRow new
						cellGap: 4 withScalingFactor;
						layoutInset: (Rectangle left: 12 withScalingFactor right: 0 top: 0 bottom: 0);
						addMorphBack: (SBStringMorph new contents: field name asString);
						addMorphBack: (SBExplorer on: (field getValueFor: self)))]])]