<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Version.cfc Unit Tests</title>
    <style>
        body {
            margin-left: 25%;
            margin-right: 25%;
        }
    </style>
</head>
<body>

<cfscript>
    Tester = new UnitTester("Version.cfc");

    Tester.BeginTests("Init");

    Tester.RunTest("Init", () => {
        var NewInstance = new Models.Version(10,12);
        var MajorVersion = NewInstance.GetMajor();
        var MinorVersion = NewInstance.GetMinor();
        Assert::NumberEqualTo(MajorVersion, 10);
        Assert::NumberEqualTo(MinorVersion, 12);
    });

    Tester.RunTest("Init, negative values clamped to zero", () => {
        var NewInstance = new Models.Version(-1,-1);
        var MajorVersion = NewInstance.GetMajor();
        var MinorVersion = NewInstance.GetMinor();
        Assert::NumberEqualTo(MajorVersion, 0);
        Assert::NumberEqualTo(MinorVersion, 0);
    });

    Tester.EndTests();

    Tester.BeginTests("Version::FromString");

    Tester.RunTest("Init", () => {
        var NewInstance = Models.Version::FromString("1.2.3.4");
        var MajorVersion = NewInstance.GetMajor();
        var MinorVersion = NewInstance.GetMinor();
        Assert::NumberEqualTo(MajorVersion, 1);
        Assert::NumberEqualTo(MinorVersion, 9);
    });

    Tester.EndTests();

    Tester.BeginTests("Version::CompareTo");

    BaseVersionString = "4.1.2.3";
    BaseVersion = Models.Version::FromString(BaseVersionString);

    Tester.RunTest("Minor version greater than compared version", () => {
        var compareVersionString = "4.1.3.3";
        var compareVersion = Models.Version::FromString(compareVersionString);
        Assert::NumberEqualTo(BaseVersion.CompareTo(compareVersion), -1);
    });

    Tester.RunTest("Major version greater than compared version", () => {
        var compareVersionString = "5.1.2.3";
        var compareVersion = Models.Version::FromString(compareVersionString);
        Assert::NumberEqualTo(BaseVersion.CompareTo(compareVersion), -1);
    });

    Tester.RunTest("Minor version lesser than compared version", () => {
        var compareVersionString = "4.1.1.3";
        var compareVersion = Models.Version::FromString(compareVersionString);
        Assert::NumberEqualTo(BaseVersion.CompareTo(compareVersion), 1);
    });

    Tester.RunTest("Major version lesser than compared version", () => {
        var compareVersionString = "3.1.2.3";
        var compareVersion = Models.Version::FromString(compareVersionString);
        Assert::NumberEqualTo(BaseVersion.CompareTo(compareVersion), 1);
    });

    Tester.RunTest("Version equal to compared version", () => {
        var compareVersionString = BaseVersionString;
        var compareVersion = Models.Version::FromString(compareVersionString);
        Assert::NumberEqualTo(BaseVersion.CompareTo(compareVersion), 0);
    });

    Tester.EndTests();
</cfscript>

</body
></html>