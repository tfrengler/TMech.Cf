component displayname="StructValue" extends="ConstraintChain" modifier="final" output="false" accessors="false" persistent="true" {

    private StructValue function Init(required boolean negated) output = false {
        super.init(arguments.negated);
        return this;
    }

    public static StructValue function Is() output = false {
        return new StructValue(false);
    }

    public static StructValue function IsNot() output = false {
        return new StructValue(true);
    }

    /**
     * @hint Asserts that a structure contains a certain key, regardless of the value.
     */
    public StructValue function ContainingKey(required string key) output = false {

        var capturedExpectedValue = arguments.key;

        var testFn = (struct value) => {
            return structKeyExists(arguments.value, capturedExpectedValue);
        };

        var failMessage = variables.negated
            ? "Expected key #capturedExpectedValue# NOT to exist in the struct"
            : "Expected key #capturedExpectedValue# to exist in the struct";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Struct"
            )
        );

        return this;
    }

    /**
     * @hint Asserts that a struct contains a certain value. Searches both top level and nested structures.
     * Comparison between items is done using standard equality check and thus only works for simple values.
     * For structures with complex values you can use the SatisfiedBy-methods.
     */
    public StructValue function ContainingValue(required any value) output = false {

        var capturedExpectedValue = arguments.value;

        var testFn = (struct value) => {
            // If we don't do this check then structFindValue will throw
            if (!isSimpleValue(capturedExpectedValue)) {
                return false;
            }

            return structFindValue(
                top   = arguments.value,
                key   = capturedExpectedValue,
                scope = "one")
            .len() > 0;
        };

        var failMessage = variables.negated
            ? "Expected value NOT to exist in the struct"
            : "Expected value to exist in the struct";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Struct"
            )
        );

        return this;
    }

    /**
     * @hint Asserts that a struct contains a certain value at a specific key. Searches both top level and nested structures.
     * Comparison between items is done using standard equality check and thus only works for simple values.
     * For structures with complex values you can use the SatisfiedBy-methods.
     */
    public StructValue function ContainingValueAtKey(required string key, required any value) output = false {

        var capturedExpectedValue = arguments.value;
        var capturedKey = arguments.key;

        var testFn = (struct value) => {
            if (!isSimpleValue(capturedExpectedValue)) {
                return false;
            }

            var findResult = structFindKey(
                top   = arguments.value,
                key   = capturedKey,
                scope = "one"
            );

            if (findResult.len() == 0) {
                return false;
            }

            var actualValue = findResult[1].value;
            if (!isSimpleValue(actualValue)) {
                return false;
            }

            return actualValue == capturedExpectedValue;
        };

        var failMessageExpectedValue = isSimpleValue(arguments.value)
            ? arguments.value
            : "[complex value]";

        var failMessage = variables.negated
            ? "Expected value at key #capturedKey# in the struct to NOT be equal to: #failMessageExpectedValue#"
            : "Expected value at key #capturedKey# in the struct to be equal to: #failMessageExpectedValue#";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Struct"
            )
        );

        return this;
    }

    /**
     * @hint Asserts that a struct contains a value at a specific key that satisfies a predicate. Searches both top level and nested structures.
     *
     * @predicate A function to test the value against. Receives the value as an argument and is expected to return true or false.
     */
    public StructValue function ValueAtKeySatisfiedBy(required string key, required function predicate) output = false {

        var capturedKey = arguments.key;
        var capturedPredicate = arguments.predicate;

        var testFn = (struct value) => {

            var findResult = structFindKey(
                top   = arguments.value,
                key   = capturedKey,
                scope = "one"
            );

            if (findResult.len() == 0) {
                return false;
            }

            var actualValue = findResult[1].value;
            return capturedPredicate(actualValue);
        };

        var failMessage = variables.negated
            ? "Expected value at key #capturedKey# in the struct to NOT be satisfied by predicate "
            : "Expected value at key #capturedKey# in the struct to be satisfied by predicate ";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Struct"
            )
        );

        return this;
    }

    /**
     * @hint Asserts that a struct contains a key and/or value that satisfies a predicate. Nested structures are not enumerated.
     *
     * @predicate A function that receives: the current key, the current value and a reference to the struct.
     * This is called against each item in the structure and is expected to return a boolean.
     */
    public StructValue function SatisfiedByAny(required function predicate) output = false {

        var capturedPredicate = arguments.predicate;

        var testFn = (struct value) => {
            return structSome(arguments.value, capturedPredicate);
        };

        var failMessage = variables.negated
            ? "Expected at least one key/value in the struct to NOT be satisfied by predicate "
            : "Expected at least one key/value in the struct to be satisfied by predicate ";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Struct"
            )
        );

        return this;
    }

    /**
     * @hint Asserts that a struct contains only key and/or value that satisfies a predicate. Nested structures are not enumerated.
     *
     * @predicate A function that receives: the current key, the current value and a reference to the struct.
     * This is called against each item in the structure and is expected to return a boolean.
     */
    public StructValue function SatisfiedByAll(required function predicate) output = false {

        var capturedPredicate = arguments.predicate;

        var testFn = (struct value) => {
            return structEvery(arguments.value, capturedPredicate);
        };

        var failMessage = variables.negated
            ? "Expected all key/value-pairs in the struct to NOT be satisfied by predicate "
            : "Expected all key/value-pairs in the struct to be satisfied by predicate ";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Struct"
            )
        );

        return this;
    }

    /**
     * @hint Asserts that a struct has no keys.
     * A struct with keys where the values are missing (zero, empty string, null etc) is not considered empty.
     */
    public StructValue function Empty() output = false {

        var testFn = (struct value) => {
            return structIsEmpty(arguments.value);
        };

        var failMessage = variables.negated
            ? "Expected struct to NOT be empty "
            : "Expected struct to be empty ";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Struct"
            )
        );

        return this;
    }
    /*
    public StructValue function EqualTo(required struct otherStruct) output = false {

        var capturedOtherStruct = arguments.otherStruct;

        var testFn = (struct value) => {
            // return structEquals(arguments.value, capturedOtherStruct);
        };

        var failMessage = variables.negated
            ? "Expected structs to NOT be equal"
            : "Expected structs to be equal";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Struct"
            )
        );

        return this;
    }
    */
}