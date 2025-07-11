component displayname="StringValue" modifier="final" output="false" accessors="false" persistent="true"
{
    property name="discriminator" type="boolean" getter="false" setter="false";

    private StringValue function Init(required bool discriminator) output = false {
        variables.discriminator = arguments.discriminator;
        return this;
    }

    public static StringValue function Is() output = false {
        return new StringValue(false);
    }

    public static StringValue function IsNot() output = false {
        return new StringValue(true);
    }

    private void function ThrowHelper(required string message, required string expected, required string actual) output = false {
        throw(
            message = arguments.message,
            detail = "
                EXPECTED
                ----Length: #len(arguments.expected)#
                ----Value: #arguments.expected#

                ACTUAL
                ----Length: #len(arguments.actual)#
                ----Value: #arguments.actual#"
            ,
            type = Assert::GetAssertionType()
        );
    }

    public StringConstraint function Nothing() output = false {

        var predicate = (required string value) => {

            if (variables.discriminator == false && isNull(arguments.value)) {
                return;
            }

            if (variables.discriminator == true && isNull(arguments.value)) {
                throw("Expected a string to not be null, empty or consist entirely of whitespace but it is null", Assert::GetAssertionType());
            }

            var stringIsEmpty = trim(arguments.value).len() == 0;

            if (stringIsEmpty && variables.discriminator == true) {
                throw("Expected a string to have a value but it is empty or consists entirely of whitespace", Assert::GetAssertionType());
            }

            if (!stringIsEmpty && variables.discriminator == false) {
                throw(
                    "Expected string to be null, empty or consist entirely of whitespace but it has a length of #arguments.value.len()# and a value of: #arguments.value#",
                    Assert::GetAssertionType()
                );
            }
        }

        return new StringConstraint(predicate);
    }

    public StringConstraint function EqualTo(required string expectedValue) output = false {

        var outerArgs = arguments;
        var predicate = (required string value) => {

            if (variables.discriminator == false && isNull(arguments.value)) {
                throw(
                    "Expected a string to equal another string in value but it is null",
                    Assert::GetAssertionType()
                );
            }

            var valuesAreEqual = outerArgs.expectedValue == arguments.value;

            if (!valuesAreEqual && variables.discriminator == false) {
                ThrowHelper(
                    "Expected a string to equal another string in value but they differ",
                    outerArgs.expectedValue,
                    arguments.value
                );
            }

            if (valuesAreEqual && variables.discriminator == true) {
                ThrowHelper(
                    "Expected a string to not equal another string in value but they appear to be the same",
                    outerArgs.expectedValue,
                    arguments.value
                );
            }
        };

        return new StringConstraint(predicate);
    }

    public StringConstraint function Containing(required string expectedValue) output = false {

        var outerArgs = arguments;
        var predicate = (required string value) => {

            if (variables.discriminator == false && isNull(arguments.value)) {
                throw(
                    "Expected a string to contain a certain value but it is null",
                    Assert::GetAssertionType()
                );
            }

            var valueContainsExpected = find(outerArgs.expectedValue, arguments.value, 0) > 0;

            if (!valueContainsExpected && variables.discriminator == false) {
                ThrowHelper(
                    "Expected a string to contain a certain value but it does not",
                    outerArgs.expectedValue,
                    arguments.value
                );
            }

            if (valueContainsExpected && variables.discriminator == true) {
                ThrowHelper(
                    "Expected a string to not contain a certain value but it does",
                    outerArgs.expectedValue,
                    arguments.value
                );
            }
        };

        return new StringConstraint(predicate);
    }

    public StringConstraint function StartingWith(required string expectedValue) output = false {

        var outerArgs = arguments;
        var predicate = (required string value) => {

            if (variables.discriminator == false && isNull(arguments.value)) {
                throw(
                    "Expected a string to start with a certain value but it is null",
                    Assert::GetAssertionType()
                );
            }

            var valueStartsWithExpected = find(outerArgs.expectedValue, arguments.value, 0) == 1;

            if (!valueStartsWithExpected && variables.discriminator == false) {
                ThrowHelper(
                    "Expected a string to start with a certain value but it does not",
                    outerArgs.expectedValue,
                    arguments.value
                );
            }

            if (valueStartsWithExpected && variables.discriminator == true) {
                ThrowHelper(
                    "Expected a string to not start with a certain value but it does",
                    outerArgs.expectedValue,
                    arguments.value
                );
            }
        };

        return new StringConstraint(predicate);
    }

    public StringConstraint function EndingWith(required string expectedValue) output = false {

        var outerArgs = arguments;
        var predicate = (required string value) => {

            if (variables.discriminator == false && isNull(arguments.value)) {
                throw(
                    "Expected a string to end with a certain value but it is null",
                    Assert::GetAssertionType()
                );
            }

            var valueEndsWithExpected = right(arguments.value, len(outerArgs.expectedValue)) == outerArgs.expectedValue;

            if (!valueEndsWithExpected && variables.discriminator == false) {
                ThrowHelper(
                    "Expected a string to end with a certain value but it does not",
                    outerArgs.expectedValue,
                    arguments.value
                );
            }

            if (valueEndsWithExpected && variables.discriminator == true) {
                ThrowHelper(
                    "Expected a string to not end with a certain value but it does",
                    outerArgs.expectedValue,
                    arguments.value
                );
            }
        };

        return new StringConstraint(predicate);
    }

    public StringConstraint function Matching(required string expectedValue) output = false {

        var outerArgs = arguments;
        var predicate = (required string value) => {

            if (variables.discriminator == false && isNull(arguments.value)) {
                throw(
                    "Expected a string to match a certain pattern but it is null",
                    Assert::GetAssertionType()
                );
            }

            var valueMeetsExpectedResult = reMatch(outerArgs.expectedValue, arguments.value).len() > 0;

            if (!valueMeetsExpectedResult && variables.discriminator == false) {
                ThrowHelper(
                    "Expected a string to match a certain pattern but it does not",
                    outerArgs.expectedValue,
                    arguments.value
                );
            }

            if (valueMeetsExpectedResult && variables.discriminator == true) {
                ThrowHelper(
                    "Expected a string to not match a certain pattern but it does",
                    outerArgs.expectedValue,
                    arguments.value
                );
            }
        };

        return new StringConstraint(predicate);
    }
}