as yet unclassified
do

	methodCommands := (class organization listAtCategoryNamed: category) collect: [:selector |
		(SBDeleteMethodCommand newFor: artefact) target: class >> selector].
	methodCommands do: #do.
	class organization removeCategory: category