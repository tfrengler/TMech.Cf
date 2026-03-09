component displayname="NumberValue" extends="ConstraintChain" modifier="final" output="false" accessors="false" persistent="true" {

    private NumberValue function Init(required boolean negated) output = false {
        super.init(arguments.negated);
        return this;
    }

    public static NumberValue function Is() output = false {
        return new NumberValue(false);
    }

    public static NumberValue function IsNot() output = false {
        return new NumberValue(true);
    }

    public NumberValue function EqualTo(required numeric expectedValue) output = false {

        var capturedExpectedValue = arguments.expectedValue;

        var testFn = (numeric value) => {
            return arguments.value == capturedExpectedValue;
        };

        var failMessage = variables.negated
            ? "Expected number NOT to equal: #capturedExpectedValue#"
            : "Expected number to equal: #capturedExpectedValue#";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Number"
            )
        );

        return this;
    }

    public NumberValue function LessThanOrEqualToZero() output = false {

        var testFn = (numeric value) => {
            return arguments.value < 1;
        };

        var failMessage = variables.negated
            ? "Expected number NOT to be less than or equal to zero"
            : "Expected number to be less than or equal to zero";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Number"
            )
        );

        return this;
    }

    public NumberValue function Zero() output = false {

        var testFn = (numeric value) => {
            return arguments.value == 0;
        };

        var failMessage = variables.negated
            ? "Expected number NOT to be zero"
            : "Expected number to be zero";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Number"
            )
        );

        return this;
    }

    public NumberValue function GreaterThan(required numeric expectedValue) output = false {

        var capturedExpectedValue = arguments.expectedValue;

        var testFn = (numeric value) => {
            return arguments.value > capturedExpectedValue;
        };

        var failMessage = variables.negated
            ? "Expected number NOT to be greater than: #capturedExpectedValue#"
            : "Expected number to be greater than: #capturedExpectedValue#";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Number"
            )
        );

        return this;
    }

    public NumberValue function LessThan(required numeric expectedValue) output = false {

        var capturedExpectedValue = arguments.expectedValue;

        var testFn = (numeric value) => {
            return arguments.value < capturedExpectedValue;
        };

        var failMessage = variables.negated
            ? "Expected number NOT to be lesser than: #capturedExpectedValue#"
            : "Expected number to be lesser than: #capturedExpectedValue#";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Number"
            )
        );

        return this;
    }

    public NumberValue function Between(required numeric minValueExclusive, required numeric maxValueExclusive) output = false {

        var outerArgs = arguments;

        var testFn = (numeric value) => {

            if (outerArgs.minValueExclusive >= outerArgs.maxValueExclusive) {
                throw(
                    message = "Error determining if number is in a certain range. The min value is greater than or equal to the max value",
                    detail  = "minValueExclusive: #outerArgs.minValueExclusive# | maxValueExclusive: #outerArgs.maxValueExclusive#",
                    type    = "#Constraint::GetBaseAssertionType()#.Number"
                );
            }

            return
                arguments.value > outerArgs.minValueExclusive
                && arguments.value < outerArgs.maxValueExclusive;
        };

        var failMessage = variables.negated
            ? "Expected number NOT to be between #outerArgs.minValueExclusive# and #outerArgs.maxValueExclusive#"
            : "Expected number to be between #outerArgs.minValueExclusive# and #outerArgs.maxValueExclusive#";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "Number"
            )
        );

        return this;
    }
}