as yet unclassified
arguments

	^ Array streamContents: [:s | 2 to: self submorphCount by: 2 do: [:i | s nextPut: (self submorphs at: i)]]