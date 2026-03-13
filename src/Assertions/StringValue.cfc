component displayname="StringValue" extends="ConstraintChain" modifier="final" output="false" accessors="false" persistent="true" {

    property name="ignoreCase" type="boolean" getter="true" setter="false";

    private StringValue function Init(required boolean negated) output = false {
        super.init(arguments.negated);
        variables.ignoreCase = false;
        return this;
    }

    public static StringValue function Is() output = false {
        return new StringValue(false);
    }

    public static StringValue function IsNot() output = false {
        return new StringValue(true);
    }

    public StringValue function IgnoringCase() output = false {
        variables.ignoreCase = true;
        return this;
    }

    public StringValue function EqualTo(required string expectedValue) output = false {

        var capturedExpectedValue = arguments.expectedValue;

        var testFn = (string value) => {
            return variables.ignoreCase
                ? compareNoCase(arguments.value, capturedExpectedValue) == 0
                : compare(arguments.value, capturedExpectedValue) == 0
        };

        var failMessage = variables.negated
            ? "Expected string - #variables.ignoreCase ? "" : "not"# ignoring case - NOT to equal: #capturedExpectedValue#"
            : "Expected string - #variables.ignoreCase ? "" : "not"# ignoring case - to equal: #capturedExpectedValue#";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "String"
            )
        );

        return this;
    }

    public StringValue function Nothing() output = false {

        var testFn = (string value) => {
            return arguments.value.trim().len() == 0;
        };

        var failMessage = variables.negated
            ? "Expected string NOT to be nothing (empty or consisting entirely of whitespace)"
            : "Expected string to be nothing (empty or consisting entirely of whitespace)"

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "String"
            )
        );

        return this;
    }

    public StringValue function StartingWith(required string expectedValue) output = false {

        var capturedExpectedValue = arguments.expectedValue;

        var testFn = (string value) => {
            return variables.ignoreCase
                ? findNoCase(capturedExpectedValue, arguments.value) == 1
                : find(capturedExpectedValue, arguments.value) == 1
        };

        var failMessage = variables.negated
            ? "Expected string - #variables.ignoreCase ? "" : "not"# ignoring case - NOT to start with: #capturedExpectedValue#"
            : "Expected string - #variables.ignoreCase ? "" : "not"# ignoring case - to start with: #capturedExpectedValue#";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "String"
            )
        );

        return this;
    }

    public StringValue function EndingWith(required string expectedValue) output = false {

        var capturedExpectedValue = arguments.expectedValue;

        var testFn = (string value) => {
            var endOfString = right(arguments.value, len(capturedExpectedValue));
            return variables.ignoreCase
                ? compareNoCase(endOfString, capturedExpectedValue) == 0
                : compare(endOfString, capturedExpectedValue) == 0
        };

        var failMessage = variables.negated
            ? "Expected string - #variables.ignoreCase ? "" : "not"# ignoring case - NOT to end with: #capturedExpectedValue#"
            : "Expected string - #variables.ignoreCase ? "" : "not"# ignoring case - to end with: #capturedExpectedValue#";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "String"
            )
        );

        return this;
    }

    public StringValue function Containing(required string expectedValue) output = false {

        var capturedExpectedValue = arguments.expectedValue;

        var testFn = (string value) => {
            return variables.ignoreCase
                ? findNoCase(capturedExpectedValue, arguments.value) > 0
                : find(capturedExpectedValue, arguments.value) > 0
        };

        var failMessage = variables.negated
            ? "Expected string - #variables.ignoreCase ? "" : "not"# ignoring case - NOT to contain: #capturedExpectedValue#"
            : "Expected string - #variables.ignoreCase ? "" : "not"# ignoring case - to contain: #capturedExpectedValue#";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "String"
            )
        );

        return this;
    }

    public StringValue function Matching(required string expectedValue) output = false {

        var capturedExpectedValue = arguments.expectedValue;

        var testFn = (string value) => {
            return variables.ignoreCase
                ? reMatchNoCase(capturedExpectedValue, arguments.value).len() > 0
                : reMatch(capturedExpectedValue, arguments.value).len() > 0
        };

        var failMessage = variables.negated
            ? "Expected string - #variables.ignoreCase ? "" : "not"# ignoring case - NOT to match: #capturedExpectedValue#"
            : "Expected string - #variables.ignoreCase ? "" : "not"# ignoring case - to match: #capturedExpectedValue#";

        variables.constraints.append(
            new Constraint(
                negated         = variables.negated,
                testFn          = testFn,
                failMessage     = failMessage,
                exceptionType   = "String"
            )
        );

        return this;
    }
}