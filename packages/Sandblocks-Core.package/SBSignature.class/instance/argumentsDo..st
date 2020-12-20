as yet unclassified
argumentsDo: aBlock

	2 to: self submorphCount by: 2 do: [:i | aBlock value: (self submorphs at: i)]