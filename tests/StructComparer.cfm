<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Struct comparer tests</title>
    <style>
        body {
            margin-left: 20%;
            margin-right: 20%;
        }
    </style>
</head>
<body>

<cfoutput>
    <cfif !structKeyExists(FORM, "doTest") >
        <form action="" method="POST">
            <input name="doTest" type="hidden" value="true" />
            <button type="submit">EXECUTE TESTS</button>
            <cfabort/>
        </form>
    </cfif>
</cfoutput>

<cfscript>
    /*
        With strict equality check and structs with similar values but different types then fail
        Without strict equality check and structs with similar values but different types then pass
        Array comparison (values equal in sequence) = pass
        Array comparison (values equal out of sequence) = fail
        Struct recursion as member
        Struct recursion as array value
        Struct recursion loop detection and prevention
        Complex values that differ (in type) with strict equality check = fail
        Complex values that differ (in type) without strict equality check = fail
        Complex values that are equal (in type) with strict equality check = pass
        Complex values that are equal (in type) without strict equality check = pass
        Max depth check that fails
    */

    Tester = new TestRunner("StructComparer.cfc");
    expectedAssertionType = "#Assertions.Constraint::GetBaseAssertionType()#.Struct";

    Tester.BeginTests("AreSimilar");

        Tester.RunTest("With strict equality check and structs with similar values but different types then fail", () => {

            var comparer = new Utils.StructComparer().WithTracing();

            var first = {
                string: "string",
                number: 42,
                bool: true
            };

            var second = {
                string: "string",
                number: "42",
                bool: true
            };

            Assert::IsFalse(comparer.AreSimilar(first, second));
            writeDump(comparer.GetTraceLog());
        });

    Tester.EndTests();
</cfscript>
</body>
</html>
