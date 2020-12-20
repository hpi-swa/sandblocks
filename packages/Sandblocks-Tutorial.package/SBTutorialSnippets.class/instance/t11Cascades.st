as yet unclassified
t11Cascades

	SBLabel text: [
		'To create cascades, multiselection comes in handy.
Select the first message, press v, navigate to the other messages and
also press v. Then press ;'].
	self changeTableLayout.
	self vResizing: #shrinkWrap.
	self hResizing: #shrinkWrap.
	SBLabel text: [
		'To start a cascade, simply press ; on an existing message send. Then
use the usuall list operators to add more sends (+ * .)'].
	self color: 'red'