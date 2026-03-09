component displayname="AnyValue" extends="ConstraintChain" modifier="final" output="false" accessors="false" persistent="true" {

    private AnyValue function Init(required boolean negated) output = false {
        super.init(arguments.negated);
        return this;
    }

    public static AnyValue function Is() output = false {
        return new AnyValue(false);
    }

    public static AnyValue function IsNot() output = false {
        return new AnyValue(true);
    }

    public AnyValue function String() output = false {

        var testFn = (string value) => {
            var actualType = arguments.value.getClass().getName();
            return actualType == "java.lang.String";
        };

        var failMessage = variables.negated
            ? "Expected object NOT to be a string"
            : "Expected object to be a string";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Any"
            )
        );

        return this;
    }

    public AnyValue function Numeric() output = false {

        var testFn = (any value) => {
            var actualType = arguments.value.getClass().getName();
            return (
                actualType == "java.lang.Long" ||
                actualType == "java.lang.Double" ||
                actualType == "java.math.BigDecimal");
        };

        var failMessage = variables.negated
            ? "Expected object NOT to be a number"
            : "Expected object to be a number";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Any"
            )
        );

        return this;
    }

    public AnyValue function Array() output = false {

        var testFn = (any value) => {
            var actualType = arguments.value.getClass().getName();
            return actualType == "lucee.runtime.type.ArrayImpl";
        };

        var failMessage = variables.negated
            ? "Expected object NOT to be an array"
            : "Expected object to be an array";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Any"
            )
        );

        return this;
    }

    public AnyValue function Struct() output = false {

        var testFn = (any value) => {
            var actualType = arguments.value.getClass().getName();
            return actualType == "lucee.runtime.type.StructImpl";
        };

        var failMessage = variables.negated
            ? "Expected object NOT to be a struct"
            : "Expected object to be a struct";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Any"
            )
        );

        return this;
    }

    public AnyValue function Boolean() output = false {

        var testFn = (any value) => {
            var actualType = arguments.value.getClass().getName();
            return actualType == "java.lang.Boolean";
        };

        var failMessage = variables.negated
            ? "Expected object NOT to be a boolean"
            : "Expected object to be a boolean";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Any"
            )
        );

        return this;
    }

    public AnyValue function Throwing() output = false {

        var testFn = (function value) => {
            try {
                arguments.value();
                return false;
            }
            catch (any error) {
                return true;
            }
        };

        var failMessage = variables.negated
            ? "Expected function to NOT throw"
            : "Expected function to throw";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Any"
            )
        );

        return this;
    }
}