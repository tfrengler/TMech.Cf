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
        ✅ With a struct as member that is equal in value then pass
        ✅ With an array as member that contains a struct that is equal in value then pass
        ✅ Struct recursion loop detection and prevention
        Complex values that differ (in type) with strict equality check = fail
        Complex values that differ (in type) without strict equality check = fail
        Complex values that are equal (in type) with strict equality check = pass
        Complex values that are equal (in type) without strict equality check = pass
        Max depth check that fails on nested structs
        Max depth check that fails on nested arrays
    */


    void function AssertRecursedIntoArray(required array traceLog, required numeric depth) output = true
    {
        var outerArgs = arguments;
        var recursed = arguments
            .traceLog
            .some((x) => reMatch("^Found array.*\(depth: #outerArgs.depth#\)$", arguments.x).len() > 0);

        if (!recursed) {
            writeDump(arguments.traceLog);
            throw("Expected tracelog to indicate that we recursed into array at depth #arguments.depth# but we didn't");
        }
    }

    void function AssertRecursedIntoStruct(required array traceLog, required numeric depth) output = true
    {
        var outerArgs = arguments;
        var recursed = arguments
            .traceLog
            .some((x) => arguments.x == "Recursing into struct (depth: #outerArgs.depth#)");

        if (!recursed) {
            writeDump(arguments.traceLog);
            throw("Expected tracelog to indicate that we recursed into struct at depth #arguments.depth# but we didn't");
        }
    }

    void function AssertSameInstanceDetection(required array traceLog, required numeric depth) output = true
    {
        var outerArgs = arguments;
        var recursed = arguments
            .traceLog
            .some((x) => arguments.x == "Structs refer to the same instance, skip comparison (depth: #outerArgs.depth#)");

        if (!recursed) {
            writeDump(arguments.traceLog);
            throw("Expected tracelog to indicate that we detected the same struct instances being compared at depth #arguments.depth# but we didn't");
        }
    }

    void function AssertPreviouslyComparedDetection(required array traceLog, required numeric depth) output = true
    {
        var outerArgs = arguments;
        var recursed = arguments
            .traceLog
            .some((x) => arguments.x == "Structs have already been compared (depth: #outerArgs.depth#)");

        if (!recursed) {
            writeDump(arguments.traceLog);
            throw("Expected tracelog to indicate that we detected the same struct instances having been previously compared at depth #arguments.depth# but we didn't");
        }
    }

    Tester = new TestRunner("StructComparer.cfc");

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
        });

    Tester.EndTests();

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
            AssertRecursedIntoArray(comparer.GetTraceLog(), 1);

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
            AssertRecursedIntoArray(comparer.GetTraceLog(), 1);
        });

    Tester.EndTests();

    Tester.BeginTests("Nested structs");

        Tester.RunTest("With a struct as member that is equal in value then pass", () => {

            var comparer = new Utils.StructComparer().WithTracing();
            var dateNow = now();

            var first = {
                "number": 82,
                "struct": {
                    "string" :"a string",
                    "integer" :42,
                    "float" :84.42,
                    "bool" :true,
                    "date" :dateNow
                }
            };

            var second = {
                "number": 82,
                "struct": {
                    "string" :"a string",
                    "integer" :42,
                    "float" :84.42,
                    "bool" :true,
                    "date" :dateNow
                }
            };

            Assert::IsTrue(comparer.AreSimilar(first, second));
            AssertRecursedIntoStruct(comparer.GetTraceLog(), 1);
        });

        Tester.RunTest("With an array as member that contains a struct that is equal in value then pass", () => {

            var comparer = new Utils.StructComparer().WithTracing();
            var dateNow = now();

            var first = {
                "number": 82,
                "array": [
                    456,
                    {
                        "string" :"a string",
                        "integer" :42,
                        "float" :84.42,
                        "bool" :true,
                        "date" :dateNow
                    }
                ]
            };

            var second = {
                "number": 82,
                "array": [
                    456,
                    {
                        "string" :"a string",
                        "integer" :42,
                        "float" :84.42,
                        "bool" :true,
                        "date" :dateNow
                    }
                ]
            };

            Assert::IsTrue(comparer.AreSimilar(first, second));
            AssertRecursedIntoArray(comparer.GetTraceLog(), 1);
            AssertRecursedIntoStruct(comparer.GetTraceLog(), 2);
        });

    Tester.EndTests();

    Tester.BeginTests("Nested structs recursion detection");

        Tester.RunTest("With two structs with a struct as member that is a reference to the first then pass", () => {

            var comparer = new Utils.StructComparer().WithTracing();
            var dateNow = now();

            var first = {
                "number": 82,
                "struct": {}
            };

            first.struct = first;

            var second = {
                "number": 82,
                "struct": first
            };

            var result = comparer.AreSimilar(first, second);
            Assert::IsTrue(result);

            AssertSameInstanceDetection(comparer.GetTraceLog(), 2);
        });

        Tester.RunTest("With two structs with a struct as member that has a struct as member that is a self-reference then fail", () => {

            var comparer = new Utils.StructComparer().WithTracing();
            var dateNow = now();

            var first = {
                "number": 82,
                "struct": {
                    "bool": true,
                    "refToSelf": {}
                }
            };

            first.struct.refToSelf = first;

            var second = {
                "number": 82,
                "struct": {
                    "bool": true,
                    "refToSelf": {}
                }
            };

            second.struct.refToSelf = second;

            Assert::IsFalse(comparer.AreSimilar(first, second));
            var traceLog = comparer.GetTraceLog();

            AssertRecursedIntoStruct(traceLog, 1);
            AssertPreviouslyComparedDetection(traceLog, 2);
        });

    Tester.EndTests();

    Tester.BeginTests("Max depth");

        Tester.RunTest("With struct with 4 nested structs and max depth 3 then throw", () => {

            var comparer = new Utils.StructComparer().WithMaxDepth(3).WithTracing();

            var first = {
                "number": 82,
                "struct1": {
                    "struct2": {
                        "struct3": {
                            "struct4": {
                                "dummy": true
                            }
                        }
                    }
                }
            };

            var second = {
                "number": 82,
                "struct1": {
                    "struct2": {
                        "struct3": {
                            "struct4": {
                                "dummy": true
                            }
                        }
                    }
                }
            };

            Assert::Throws(() => comparer.AreSimilar(first, second), "StructComparer.MaxDepthReached");
        });

        Tester.RunTest("With struct with 4 nested arrays and max depth 3 then throw", () => {

            var comparer = new Utils.StructComparer().WithMaxDepth(3).WithTracing();

            var first = {
                "number": 82,
                "array": [
                    [
                        [
                            []
                        ]
                    ]
                ]
            };

            var second = {
                "number": 82,
                "array": [
                    [
                        [
                            []
                        ]
                    ]
                ]
            };

            Assert::Throws(() => comparer.AreSimilar(first, second), "StructComparer.MaxDepthReached");
        });

    Tester.EndTests();
    */
</cfscript>
</body>
</html>
