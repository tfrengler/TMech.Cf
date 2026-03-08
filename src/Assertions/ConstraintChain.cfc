component displayname="ConstraintChain" modifier="abstract" output="false" accessors="false" persistent="true" {

    property name="negated"     type="boolean"  getter="true" setter="false";
    property name="constraints" type="array"    getter="true" setter="false";

    public ConstraintChain function Init(required boolean negated) {
        variables.negated = arguments.negated;
        variables.constraints = [];
        return this;
    }

    public ConstraintChain function And() {
        return this;
    }

    public void function ApplyAll(required any value) {
        for (var currentConstraint in variables.constraints) {
            currentConstraint.Apply(value);
        }
    }
}
