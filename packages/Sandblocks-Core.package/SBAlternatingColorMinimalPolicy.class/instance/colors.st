as yet unclassified
colors

	^ SBToggledCode
		comment: ''
		active: 3
		do: {
			[{Color red. Color green. Color blue}].
			[{Color black. Color gray. Color white}].
			[
				{
					Color tungsten.
					(Color r: 0.33 g: 0.33 b: 0.33).
					(Color r: 0.66 g: 0.66 b: 0.66).
					(Color r: 0.77 g: 0.77 b: 0.77)
				}].
			[
				{Color white. (Color r: 0.88 g: 0.88 b: 0.88). (Color r: 0.77 g: 0.77 b: 0.77). (Color r: 0.7 g: 0.7 b: 0.7)}]
		}