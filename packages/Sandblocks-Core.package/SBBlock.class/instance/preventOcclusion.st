testing
preventOcclusion

	^ self withDecorator: SBMoveDecorator do: [:d | d preventOcclusion] ifAbsent: [false]