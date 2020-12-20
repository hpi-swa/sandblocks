as yet unclassified
messageParts

	^ Array streamContents: [:s | 1 to: self submorphCount  by: 2 do: [:i | s nextPut: (self submorphs at: i)]]