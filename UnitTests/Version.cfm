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

<h1>Version.cfc unit tests:</h1>

<cfscript>

    include "UnitTestLib.cfm";

    writeOutput("<fieldset><legend><h2>Version::CompareTo</h2></legend>");

    baseVersionString = "126.0.6478.126";
    baseVersion = Models.Version::FromString(baseVersionString);

    versionGreaterMinorString = "126.0.6478.127";
    versionGreaterMinor = Models.Version::FromString(versionGreaterMinorString);

    versionLesserMinorString = "126.0.6478.125";
    versionLesserMinor = Models.Version::FromString(versionLesserMinorString);

    versionGreaterMajorString = "127.0.6478.126";
    versionGreaterMajor = Models.Version::FromString(versionGreaterMajorString);

    versionLesserMajorString = "124.0.6478.126";
    versionLesserMajor = Models.Version::FromString(versionLesserMajorString);

    versionEqual = Models.Version::FromString(baseVersionString);

    writeOutput("<p>");
    cftimer(label="baseVersion.CompareTo(versionGreaterMinor) == -1", type="inline") {
        Assert(baseVersion.CompareTo(versionGreaterMinor) == -1, "Expected #versionGreaterMinorString# to be greater than #baseVersionString# (CompareTo() should have returned -1)");
    }
    writeOutput("</p>");

    writeOutput("<p>");
    cftimer(label="baseVersion.CompareTo(versionLesserMinor) == 1", type="inline") {
        Assert(baseVersion.CompareTo(versionLesserMinor) == 1, "Expected #versionLesserMinorString# to be lesser than #baseVersionString# (CompareTo() should have returned 1)");
    }
    writeOutput("</p>");

    writeOutput("<p>");
    cftimer(label="baseVersion.CompareTo(versionGreaterMajor) == -1", type="inline") {
        Assert(baseVersion.CompareTo(versionGreaterMajor) == -1, "Expected #versionGreaterMajorString# to be greater than #baseVersionString# (CompareTo() should have returned -1)");
    }
    writeOutput("</p>");

    writeOutput("<p>");
    cftimer(label="baseVersion.CompareTo(versionLesserMajor) == 1", type="inline") {
        Assert(baseVersion.CompareTo(versionLesserMajor) == 1, "Expected #versionLesserMajorString# to be lesser than #baseVersionString# (CompareTo() should have returned 1)");
    }
    writeOutput("</p>");
    
    writeOutput("<p>");
    cftimer(label="baseVersion.CompareTo(versionEqual) == 0", type="inline") {
        Assert(baseVersion.CompareTo(versionEqual) == 0, "Expected #baseVersionString# to be equal to #baseVersionString# (CompareTo() should have returned 0)");
    }
    writeOutput("</p>");

    writeOutput("</fieldset>")

    FinalizeTests();
</cfscript>

</body
></html>