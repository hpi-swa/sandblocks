utils
importFrom: aFileDirectory
	" clone for example https://github.com/encharm/Font-Awesome-SVG-PNG and run it on their SVGs. possibly remove icons-import first. "
	" PHTIcon importFrom: (FileDirectory default / 'Font-Awesome-SVG-PNG-master' / 'white' / 'svg') "

	aFileDirectory entriesDo: [:entry |
		entry extension = 'svg' ifTrue: [
			entry readStreamDo: [:stream | | source name |
				name := 'icon', (entry name allButLast: 4) capitalized copyReplaceAll: '-' with: '_'.
				
				source := '{1}
	^ self fromCache: #{1} ifAbsentPut: [''{2}'']' format: {name. stream contents}.
				
				self class compile: source classified: 'icons-import']]]