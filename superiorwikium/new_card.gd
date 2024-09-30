extends Control

@onready var expression = $Expression
var value: float

@export var min_operations: int = 2
@export var max_operations: int = 4
@export var mult_range: int = 10
@export var add_sub_range: int = 60
@export var div_range: int = 10

func  _ready() -> void:
	var k =generate_expression()
	expression.text = k
	value = evaluate_expression(k)

func generate_expression() -> String:
	"""
	Generates a random mathematical expression as a string.

	Parameters (Variables):
	min_operations (int): Minimum number of operations in the expression.
	max_operations (int): Maximum number of operations in the expression.
	mult_range (int): Maximum value for multiplication operands if 'use_hard_multiplication' is False.
	add_sub_range (int): Maximum value for addition and subtraction operands.
	div_range (int): Maximum value for division denominators.

	Returns:
	String: A mathematical expression in string format.
	"""

	# Determine the number of operations to include in the expression.
	var num_operations = randi() % (max_operations - min_operations + 1) + min_operations

	var numbers = []    # List to store numbers in the expression.
	var operators = []  # List to store operators in the expression.
	var operator_list = ['+', '-', '*', '/']  # Available operators.

	# Seed the random number generator for randomness.
	#randomize() #Not needed

	# Generate random operators for the expression.
	for i in range(num_operations):
		var op = operator_list[randi() % operator_list.size()]
		operators.append(op)

	# Generate the first number.
	# Since we don't know the first operator yet, we use the addition/subtraction range.
	var num = randi() % add_sub_range + 1
	numbers.append(num)

	# Generate subsequent numbers based on the preceding operator.
	for i in range(num_operations):
		var op = operators[i]

		if op == '/':
			# Generate a denominator between 1 and div_range.
			var denom = randi() % div_range + 1

			# Ensure the numerator (previous number) is a multiple of the denominator.
			var multiplier = randi() % 10 + 1  # Multiplier between 1 and 10.
			var numerator = denom * multiplier

			# Replace the previous number (numerator) with the adjusted value.
			numbers[i] = numerator
			numbers.append(denom)

		elif op == '*':
			# Handle multiplication operands.
			# Limit numbers to a smaller range for easier multiplication.
			num = randi() % mult_range + 1
			numbers.append(num)
		else:
			# For addition and subtraction, use numbers within the specified range.
			num = randi() % add_sub_range + 1
			numbers.append(num)

	# Build the expression string by interleaving numbers and operators.
	var expr_parts = []
	for i in range(num_operations):
		expr_parts.append(str(numbers[i]))     # Append the current number.
		expr_parts.append(operators[i])        # Append the current operator.

	# Append the last number after the loop ends.
	expr_parts.append(str(numbers[num_operations]))

	# Combine all parts into a single string.
	var expr_str = ' '.join(expr_parts)
	return expr_str

func evaluate_expression(expr_str: String) -> float:
	var expr = Expression.new()
	var err = expr.parse(expr_str)
	if err != OK:
		push_error("Parse error: " + expr.get_error_text())
		print(expr_str)
		return 0.0
	var result = expr.execute()
	if expr.has_execute_failed():
		push_error("Execution error: " + expr.get_error_text())
		print(expr_str)
		return 0.0
	return result
