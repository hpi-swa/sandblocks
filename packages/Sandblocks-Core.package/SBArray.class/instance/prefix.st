as yet unclassified
prefix

	^ type caseOf: {[#dynamic] -> ['{']. [#literal] -> ['#(']. [#byte] -> ['#[']} otherwise: '?'