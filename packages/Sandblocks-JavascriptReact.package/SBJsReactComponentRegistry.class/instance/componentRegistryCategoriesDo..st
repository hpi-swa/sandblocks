accessing
componentRegistryCategoriesDo: aBlock

	self componentRegistry keysAndValuesDo: [:categoryName :jsxElementReplacementsDict | aBlock value: categoryName value: jsxElementReplacementsDict]