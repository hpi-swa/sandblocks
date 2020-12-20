as yet unclassified
exampleFinished: anExample

	contextIdentityHashes := {}
	"self allWatchesDo: [:watch |
		(watch valuesForExample: anExample) ifNotNil: [:display | | snapshots |
			 (examples at: anExample ifAbsentPut: [ | slider |
				slider := SBExampleSlider new.
				self addMorphBack: slider.
				slider]).
			
			snapshots := display stackTrace select: [:assoc |
				assoc key anySatisfy: [:tuple |
					tuple first = self containingArtefact object identityHash]].
			
			contexts := snapshots collect: [:assoc | assoc key second].
			self lastSubmorph firstSubmorph contents: snapshots size asString.
			self lastSubmorph submorphs second maximumValue: snapshots size]]"