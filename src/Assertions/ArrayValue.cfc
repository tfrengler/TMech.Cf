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