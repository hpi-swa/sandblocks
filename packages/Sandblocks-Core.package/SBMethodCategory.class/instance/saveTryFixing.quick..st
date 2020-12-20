as yet unclassified
saveTryFixing: aFixBoolean quick: aQuickBoolean

	| currentName |
	currentName := self firstSubmorph contents.
	savedCategoryName ~= currentName ifTrue: [
		class organization renameCategory: savedCategoryName toBe: currentName.
		savedCategoryName := currentName].
	^ true