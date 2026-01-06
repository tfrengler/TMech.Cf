component displayname="ArrayValue" modifier="final" output="false" accessors="false" persistent="true"
{
    property name="discriminator" type="boolean" getter="false" setter="false";

    private ArrayValue function Init(required bool discriminator) output = false {
        variables.discriminator = arguments.discriminator;
        return this;
    }

    public static ArrayValue function Is() output = false {
        return new StringValue(false);
    }

    public static ArrayValue function IsNot() output = false {
        return new ArrayValue(true);
    }

    private void function ThrowHelper(required string message) output = false {
        throw(
            message = arguments.message,
            detail = "",
            type = Assert::GetAssertionType()
        );
    }

    /**
    * @hint Constraint that asserts whether an array is empty or not (contains any items)
    */
    public ArrayConstraint function Empty() output = false {

        var predicate = (required array value) => {

            if (IsNull(arguments.value.len())) {
                throw("Cannot determine whether array is empty or not because the value is null", Assert::GetAssertionType());
            }

            if (!variables.discriminator && arguments.value.len() > 0) {
                throw("Expected array to be empty but it contains #arguments.value.len()# items", Assert::GetAssertionType());
            }

            if (variables.discriminator && arguments.value.len() == 0) {
                throw("Expected array to not be empty but it contains #arguments.value.len()# items", Assert::GetAssertionType());
            }
        }

        return new ArrayConstraint(predicate);
    }
}