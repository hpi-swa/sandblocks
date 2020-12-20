as yet unclassified
do: aBlock

	start to: end by: step do: [:index |
		aBlock value: (collection at: index)]