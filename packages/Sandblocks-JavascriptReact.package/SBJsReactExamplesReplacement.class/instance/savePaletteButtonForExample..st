replacing
savePaletteButtonForExample: aJsObject

	^ SBButton new icon: SBIcon iconSave label: 'Save to Palette' do: [ | category jsxElementReplacement wrappedOwningClass |
		wrappedOwningClass := self wrappedOwningClass.
		category := UIManager default
			chooseFromOrAddTo: SBJsReactComponentRegistry defaultRegistry allCategories
			lines: nil
			title: 'Choose Category'.
		category ifNotNil: [
			Cursor wait showWhile: [
				jsxElementReplacement := SBJsReactJSXElementReplacement
					for: wrappedOwningClass
					withExample: aJsObject.
				SBJsReactComponentRegistry defaultRegistry
					addComponent: jsxElementReplacement
					withName: wrappedOwningClass componentName
					inCategory: category].
			self sandblockEditor rebuildPalette]]