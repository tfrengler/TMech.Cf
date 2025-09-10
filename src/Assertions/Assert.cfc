component displayname="Assert" modifier="final" output="false" accessors="false" persistent="true"
{
    public static string function GetAssertionType() {
        return "TMech.Assertion.Failed";
    }

    public static void function ThatString(required string value, required StringConstraint constraint) output = false {
        arguments.constraint.run(value);
    }

    public static void function ThatNumber(required numeric value, required NumberConstraint constraint) output = false {
        arguments.constraint.run(value);
    }

    public static void function That(required any value, required AnyConstraint constraint) output = false {
        arguments.constraint.run(value);
    }
}