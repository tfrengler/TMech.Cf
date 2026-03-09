component displayname="Assert" modifier="final" output="false" accessors="false" persistent="true"
{
    public static void function That(required any value, required ConstraintChain constraints) output = false {
        arguments.constraints.ApplyAll(arguments.value);
    }
}