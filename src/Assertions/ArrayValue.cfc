component displayname="ArrayValue" extends="ConstraintChain" modifier="final" output="false" accessors="false" persistent="true" {

    private ArrayValue function Init(required boolean negated) output = false {
        super.init(arguments.negated);
        return this;
    }

    public static ArrayValue function Is() output = false {
        return new ArrayValue(false);
    }

    public static ArrayValue function IsNot() output = false {
        return new ArrayValue(true);
    }

    /**
     * @hint Asserts that an array is empty, meaning its length is zero and has no items in it.
     * An array full of null-values is not considered empty.
     */
    public ArrayValue function Empty() output = false {

        var testFn = (array value) => {
            return arguments.value.len() == 0;
        };

        var failMessage = variables.negated
            ? "Expected array NOT to be empty"
            : "Expected array to be empty";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Array"
            )
        );

        return this;
    }

    /**
     * @hint Asserts that all items in the array satisfies the condition of a custom function.
     * Throws an exception if any item is not satisfied by the function.
     *
     * @predicate A custom function that is executed against each item in the array.
     * Must return true or false.
     */
    public ArrayValue function SatisfiedByAll(required function predicate) output = false {

        var outerArgs = arguments;

        var testFn = (array value) => {
            return arrayEvery(arguments.value, outerArgs.predicate);
        };

        var failMessage = variables.negated
            ? "Expected every item in array NOT to be satisfied by the predicate"
            : "Expected every item in array to be satisfied by the predicate";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Array"
            )
        );

        return this;
    }

    /**
     * @hint Asserts that any item in the array satisfies the condition of a custom function.
     * Throws an exception if no items are satisfied by the function.
     *
     * @predicate A custom function that is executed against each item in the array.
     * Must return true or false. Once true is returned assertion stops and any items
     * after that item in the array are not tested.
     */
    public ArrayValue function SatisfiedByAny(required function predicate) output = false {

        var outerArgs = arguments;

        var testFn = (array value) => {
            return arraySome(arguments.value, outerArgs.predicate);
        };

        var failMessage = variables.negated
            ? "Expected NO items in array to be satisfied by the predicate"
            : "Expected at least one item in array to be satisfied by the predicate";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Array"
            )
        );

        return this;
    }

    /**
     * @hint Asserts that an array contains a specific value.
     *
     * @expectedValue The value to find in the array. Comparison between items is done using standard equality check and thus only works for simple values.
     * For arrays with complex values you can use SatisfiedByAny or SatisfiedByAll.
     */
    public ArrayValue function Containing(required any expectedValue) output = false {

        var outerArgs = arguments;

        var testFn = (array value) => {
            return arrayFind(arguments.value, outerArgs.expectedValue) > 0;
        };

        var failMessage = variables.negated
            ? "Expected array NOT to contain: #arguments.expectedValue#"
            : "Expected array to contain: #arguments.expectedValue#";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Array"
            )
        );

        return this;
    }

    /**
     * @hint Asserts that one array is similar to another, meaning it has the same size
     * and the exact same items but not necessarily in order.
     *
     * Comparison between items is done using standard equality check and thus only works for simple values.
     * For arrays with complex values you can use SatisfiedByAny or SatisfiedByAll.
     */
    public ArrayValue function SimilarTo(required array otherArray) output = false {

        var outerArgs = arguments;

        var testFn = (array value) => {

            if (arguments.value.len() != outerArgs.otherArray.len()) {
                throw(
                    message = "Failed to determine if array is similar to other array as they have different sizes",
                    detail  = "Actual array size: #arguments.value.len()# | Other array size: #outerArgs.otherArray.len()#",
                    type    = "#Constraint::GetBaseAssertionType()#.Array"
                );
            }

            for(var item in outerArgs.otherArray) {
                if (arrayFind(arguments.value, item) == 0) {
                    return false;
                }
            }

            return true;
        };

        var failMessage = variables.negated
            ? "Expected array NOT to be similar to other array"
            : "Expected array to be similar to other array";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Array"
            )
        );

        return this;
    }

    /**
     * @hint Asserts that one array is similar to another, meaning it has the same size
     * and the exact same items in the same order.
     *
     * Comparison between items is done using standard equality check and thus only works for simple values.
     * For arrays with complex values you can use SatisfiedByAny or SatisfiedByAll.
     */
    public ArrayValue function SequenceEqualTo(required array otherArray) output = false {

        var outerArgs = arguments;

        var testFn = (array value) => {

            if (arguments.value.len() != outerArgs.otherArray.len()) {
                throw(
                    message = "Failed to determine if array is equal to other array as they have different sizes",
                    detail  = "Actual array size: #arguments.value.len()# | Other array size: #outerArgs.otherArray.len()#",
                    type    = "#Constraint::GetBaseAssertionType()#.Array"
                );
            }

            for(var index = 1; index < arguments.value.len(); index++) {
                if ( arguments.value[index] != outerArgs.otherArray[index] ) {
                    return false;
                }
            }

            return true;
        };

        var failMessage = variables.negated
            ? "Expected array NOT to be equal to other array"
            : "Expected array to be equal to other array";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Array"
            )
        );

        return this;
    }
}