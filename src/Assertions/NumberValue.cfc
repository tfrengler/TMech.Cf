component displayname="NumberValue" modifier="final" output="false" accessors="false" persistent="true"
{
    property name="discriminator" type="boolean" getter="false" setter="false";

    private NumberValue function Init(required bool discriminator) output = false {
        variables.discriminator = arguments.discriminator;
        return this;
    }

    public static NumberValue function Is() output = false {
        return new NumberValue(false);
    }

    public static NumberValue function IsNot() output = false {
        return new NumberValue(true);
    }

    private void function ThrowHelper(required string message, required string expected, required string actual) output = false {
        throw(
            message = arguments.message,
            detail = "
                EXPECTED: #arguments.expected#
                ACTUAL:   #arguments.actual#"
            ,
            type = Assert::GetAssertionType()
        );
    }

    public NumberConstraint function EqualTo(required numeric expectedValue) output = false {

        var outerArgs = arguments;
        var predicate = (required numeric value) => {

            var valuesAreEqual = outerArgs.expectedValue == arguments.value;

            if (!valuesAreEqual && variables.discriminator == false) {
                ThrowHelper(
                    "Expected a number to equal another number in value but they differ",
                    outerArgs.expectedValue,
                    arguments.value
                );
            }

            if (valuesAreEqual && variables.discriminator == true) {
                ThrowHelper(
                    "Expected a number to not equal another number in value but they appear to be the same",
                    outerArgs.expectedValue,
                    arguments.value
                );
            }
        };

        return new NumberConstraint(predicate);
    }

    public NumberConstraint function Zero() output = false {

        var predicate = (required numeric value) => {

            var valueIsZero = arguments.value == 0;

            if (!valueIsZero && variables.discriminator == false) {
                throw(message="Expected value to be zero but it is #arguments.value#", type=Assert::GetAssertionType());
            }

            if (valueIsZero && variables.discriminator == true) {
                throw(message="Expected value to not be zero but it is", type=Assert::GetAssertionType());
            }
        };

        return new NumberConstraint(predicate);
    }

    public NumberConstraint function LessThanOrEqualToZero() output = false {

        var predicate = (required numeric value) => {

            var valueIsLessThanOrEqualToZero = arguments.value <= 0;

            if (!valueIsLessThanOrEqualToZero && variables.discriminator == false) {
                throw(message="Expected value to be less than or equal to zero but it is #arguments.value#", type=Assert::GetAssertionType());
            }

            if (valueIsLessThanOrEqualToZero && variables.discriminator == true) {
                throw(message="Expected value to not be less than or equal to zero but it is #arguments.value#", type=Assert::GetAssertionType());
            }
        };

        return new NumberConstraint(predicate);
    }

    public NumberConstraint function LessThan(required numeric thresholdValue) output = false {

        var localThresholdValue = arguments.thresholdValue;
        var predicate = (required numeric value) => {

            var valueIsLessThan = arguments.value < localThresholdValue;

            if (!valueIsLessThan && variables.discriminator == false) {
                throw(message="Expected value to be less than #localThresholdValue# but it is #arguments.value#", type=Assert::GetAssertionType());
            }

            if (valueIsLessThan && variables.discriminator == true) {
                throw(message="Expected value to not be less than #localThresholdValue# but it is #arguments.value#", type=Assert::GetAssertionType());
            }
        };

        return new NumberConstraint(predicate);
    }

    public NumberConstraint function GreaterThan(required numeric thresholdValue) output = false {

        var localThresholdValue = arguments.thresholdValue;
        var predicate = (required numeric value) => {

            var valueIsLessThan = arguments.value > localThresholdValue;

            if (!valueIsLessThan && variables.discriminator == false) {
                throw(message="Expected value to be greater than #localThresholdValue# but it is #arguments.value#", type=Assert::GetAssertionType());
            }

            if (valueIsLessThan && variables.discriminator == true) {
                throw(message="Expected value to not be greater than #localThresholdValue# but it is #arguments.value#", type=Assert::GetAssertionType());
            }
        };

        return new NumberConstraint(predicate);
    }
}