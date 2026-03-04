<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Array assert tests</title>
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
    Tester = new TestRunner("Assert::ThatArray, ArrayConstraint.cfc and ArrayValue.cfc");

    Tester.BeginTests("Empty()");

        Tester.RunTest("ArrayValue::IsNot().Empty() => null - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatArray(nullValue(), Assertions.ArrayValue::IsNot().Empty());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("ArrayValue::IsNot().Empty() => ['test'] - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatArray(["test"], Assertions.ArrayValue::IsNot().Empty());
            });
        });

        Tester.RunTest("ArrayValue::IsNot().Empty() => [] - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatArray([], Assertions.ArrayValue::IsNot().Empty());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("ArrayValue::Is().Empty() => [] - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatArray([], Assertions.ArrayValue::Is().Empty());
            });
        });

        Tester.RunTest("ArrayValue::Is().Empty() => ['test'] - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatArray(["test"], Assertions.ArrayValue::Is().Empty());
            }, Assertions.Assert::GetAssertionType());
        });

    Tester.EndTests();

    Tester.BeginTests("SatisfiedByAny()");

    Tester.RunTest("ArrayValue::Is().SatisfiedByAny() => null - should throw", () => {

        Assert::Throws(() => {
            Assertions.Assert::ThatArray(
                nullValue(),
                Assertions.ArrayValue::Is().SatisfiedByAny((x) => arguments.x == "test2")
            );
        }, Assertions.Assert::GetAssertionType());
    });

    Tester.RunTest("ArrayValue::Is().SatisfiedByAny(): contains 'test2' => ['test1','test2'] - should not throw", () => {

        Assert::DoesNotThrow(() => {
            Assertions.Assert::ThatArray(
                ["test1","test2"],
                Assertions.ArrayValue::Is().SatisfiedByAny((x) => arguments.x == "test2")
            );
        })
    })

    Tester.RunTest("ArrayValue::IsNot().SatisfiedByAny(): contains 'test3' => ['test1','test2'] - should not throw", () => {

        Assert::DoesNotThrow(() => {
            Assertions.Assert::ThatArray(
                ["test1","test2"],
                Assertions.ArrayValue::IsNot().SatisfiedByAny((x) => arguments.x == "test3")
            );
        })
    });

    Tester.RunTest("ArrayValue::Is().SatisfiedByAny(): containing 'test3' => ['test1','test2'] - should throw", () => {

        Assert::Throws(() => {
            Assertions.Assert::ThatArray(
                ["test1","test2"],
                Assertions.ArrayValue::Is().SatisfiedByAny((x) => arguments.x == "test3")
            );
        }, Assertions.Assert::GetAssertionType())
    });

    Tester.RunTest("ArrayValue::IsNot().SatisfiedByAny(): containing 'test2' => ['test1','test2'] - should throw", () => {

        Assert::Throws(() => {
            Assertions.Assert::ThatArray(
                ["test1","test2"],
                Assertions.ArrayValue::IsNot().SatisfiedByAny((x) => arguments.x == "test2")
            );
        }, Assertions.Assert::GetAssertionType())
    });

    Tester.EndTests();

</cfscript>
</body>
</html>