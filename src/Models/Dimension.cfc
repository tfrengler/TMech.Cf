component displayname="Dimension" modifier="final" output="false" accessors="false" persistent="true"
{
    property name="X" type="numeric" getter="true" setter="false";
    property name="Y" type="numeric" getter="true" setter="false";

    public Dimension function Init(required numeric x, required numeric y) output = false
    {
        variables.X = arguments.X;
        variables.Y = arguments.Y;

        return this;
    }

    public boolean function IsValid() output = false
    {
        return variables.X > 0 && variables.Y > 0;
    }

    public static Dimension function None() output = false
{
        return new Dimension(0,0);
    }
}