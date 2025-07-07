/**
 * Represents a dimension in arbitrary space with a numerical X and Y component.
 */
component displayname="Dimension" modifier="final" output="false" accessors="false" persistent="true"
{
    property name="X" type="numeric" getter="true" setter="false";
    property name="Y" type="numeric" getter="true" setter="false";

    public Dimension function Init(required numeric x, required numeric y) output = false
    {
        variables.X = arguments.x;
        variables.Y = arguments.y;

        return this;
    }

    /**
     * Returns true if X and Y are above 0 and false otherwise.
     */
    public boolean function IsValid() output = false
    {
        return variables.X > 0 && variables.Y > 0;
    }

    public string function ToString() output = false
    {
        return "[ X = #variables.X# | Y = #variables.Y# ]"
    }

    /**
     * Represents the non-existent dimension where X and Y are 0.
     */
    public static Dimension function None() output = false
    {
        return new Dimension(0,0);
    }
}