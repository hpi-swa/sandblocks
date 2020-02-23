initialization
buildFrom: aNode

	SBExample
		self: [SBStateMachine new]
		args: [
			{
				'TOMStateMachine new
		initialState: #idle;
		
		from: #idle to: #combat if: [ self checkNearbyEnemies ];
		from: #combat to: #idle if: [ self target isNil ];
		from: #combat to: #idle when: #finished' parseAsSandblockWithoutSubstitution
			}]
		label: 'simple'.
	states := Dictionary newFrom: (((aNode messages gather: [:message | 
		message selector caseOf: {
			([#from:to:if:] -> [message arguments copyFrom: 1 to: 2]).
			([#from:to:when:] -> [message arguments copyFrom: 1 to: 2]).
			([#from:to:after:] -> [message arguments copyFrom: 1 to: 2]).
			([#initialState:] -> [{message arguments first}]).
			([#uponEnter:do:] -> [{message arguments first}]).
			([#uponLeave:do:] -> [{message arguments first}]).
			([#yourself] -> [{}])
		}]) asSet collect: #contents) collect: [:name | name -> (SBStateMachineState new name: name)]).
	states do: [:state | self addMorphBack: state].
	connectors := OrderedCollection new.
	aNode messages do: [:message | 
		message selector caseOf: {
			([#initialState:] -> [initialState := states at: message arguments first contents]).
			([#from:to:if:] -> [ | line |
				self
					connect: message arguments first contents
					to: message arguments second contents
					if: message arguments third]).
			([#from:to:when:] -> [ | line |
				self
					connect: message arguments first contents
					to: message arguments second contents
					if: message arguments third]).
			([#from:to:after:] -> [ | line |
				self
					connect: message arguments first contents
					to: message arguments second contents
					if: message arguments third]).
			([#uponEnter:do:] -> [(states at: message arguments first contents) addUponEnter: message arguments second]).
			([#uponLeave:do:] -> [(states at: message arguments first contents) addUponLeave: message arguments second]).
			([#yourself] -> [nil])
		}].
	self updatePositions