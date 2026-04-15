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
        ✅ With strict equality check and structs with similar values but different types then fail
        ✅ Without strict equality check and structs with similar values but different types then pass
        ✅ Without strict equality check and structs with similar simple values and types then pass
        ✅ With casesensitive keys and structs with same keys but different casing then fail
        ✅ Without casesensitive keys and structs with same keys but different casing then pass
        ✅ Array members where values are equal in sequence then pass
        ✅ Array members where values are not equal in sequence then fail
        With a struct member that is equal in value then pass
        With an array member that contains a struct that is equal in value then pass
        With a struct member that is not equal in value then fail
        With an array member that contains a struct that is not equal in value then fail
        Struct recursion loop detection and prevention
        Complex values that differ (in type) with strict equality check = fail
        Complex values that differ (in type) without strict equality check = fail
        Complex values that are equal (in type) with strict equality check = pass
        Complex values that are equal (in type) without strict equality check = pass
        Max depth check that fails on nested structs
        Max depth check that fails on nested arrays
    */

    Tester = new TestRunner("StructComparer.cfc");
    //expectedAssertionType = "#Assertions.Constraint::GetBaseAssertionType()#.Struct";
    /*
    Tester.BeginTests("Strict equality check");

        Tester.RunTest("With strict equality check and structs with similar values but different types then fail", () => {

            var comparer = new Utils.StructComparer().WithTracing();

            var first = {
                string: "string",
                number: 42
            };

            var second = {
                string: "string",
                number: "42"
            };

            Assert::IsFalse(comparer.AreSimilar(first, second));
            writeDump(comparer.GetTraceLog());
        });

        Tester.RunTest("Without strict equality check and structs with similar values but different types then pass", () => {

            var comparer = new Utils.StructComparer()
                .AllowCoercionWhenComparing()
                .WithTracing();

            var first = {
                string: "string",
                number: 42
            };

            var second = {
                string: "string",
                number: "42"
            };

            Assert::IsTrue(comparer.AreSimilar(first, second));
            writeDump(comparer.GetTraceLog());
        });

        Tester.RunTest("Without strict equality check and structs with similar simple values and types then pass", () => {

            var comparer = new Utils.StructComparer().WithTracing();
            var dateNow = now();

            var first = {
                "string": "a string",
                "integer": 42,
                "float": 84.42,
                "bool": true,
                "date": dateNow
            };

            var second = {
                "string": "a string",
                "integer": 42,
                "float": 84.42,
                "bool": true,
                "date": dateNow
            };

            Assert::IsTrue(comparer.AreSimilar(first, second));
            writeDump(comparer.GetTraceLog());
        });

    Tester.EndTests();

    Tester.BeginTests("Case sensitive keys");

        Tester.RunTest("With casesensitive keys and structs with same keys but different casing then fail", () => {

            var comparer = new Utils.StructComparer().WithTracing();
            var dateNow = now();

            var first = {
                "string": "a string",
                "integer": 42,
                "float": 84.42,
                "bool": true,
                "date": dateNow
            };

            var second = {
                "string": "a string",
                "integer": 42,
                "FLOAT": 84.42,
                "bool": true,
                "date": dateNow
            };

            Assert::IsFalse(comparer.AreSimilar(first, second));
            writeDump(comparer.GetTraceLog());
        });

        Tester.RunTest("With casesensitive keys and structs with same keys but different casing then fail", () => {

            var comparer = new Utils.StructComparer().WithCaseInsensitiveKeyComparison().WithTracing();
            var dateNow = now();

            var first = {
                "string": "a string",
                "integer": 42,
                "float": 84.42,
                "bool": true,
                "date": dateNow
            };

            var second = {
                "string": "a string",
                "integer": 42,
                "FLOAT": 84.42,
                "bool": true,
                "date": dateNow
            };

            Assert::IsTrue(comparer.AreSimilar(first, second));
            writeDump(comparer.GetTraceLog());
        });

    Tester.EndTests();
    */
    Tester.BeginTests("Array comparison");

        Tester.RunTest("Array members where values are equal in sequence then pass", () => {

            var comparer = new Utils.StructComparer().WithTracing();
            var dateNow = now();

            var first = {
                "array": [
                    "a string",
                    42,
                    84.42,
                    true,
                    dateNow
                ]
            };

            var second = {
                "array": [
                    "a string",
                    42,
                    84.42,
                    true,
                    dateNow
                ]
            };

            Assert::IsTrue(comparer.AreSimilar(first, second));
            writeDump(comparer.GetTraceLog());
        });

        Tester.RunTest("Array members where values are not equal in sequence then fail", () => {

            var comparer = new Utils.StructComparer().WithTracing();
            var dateNow = now();

            var first = {
                "array": [
                    "a string",
                    42,
                    84.42,
                    true,
                    dateNow
                ]
            };

            var second = {
                "array": [
                    "a string",
                    true,
                    84.42,
                    true,
                    dateNow
                ]
            };

            Assert::IsFalse(comparer.AreSimilar(first, second));
            writeDump(comparer.GetTraceLog());
        });

    Tester.EndTests()
</cfscript>
</body>
</html>
