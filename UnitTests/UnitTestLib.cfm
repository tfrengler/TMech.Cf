<cfscript>
failures = [];

void function Assert(required boolean condition, required string failureMessage) {
    if (!arguments.condition) {
        failures.append(arguments.failureMessage);
    }
}

void function FinalizeTests() {
    if (failures.len() > 0) {
        writeOutput("<p style='background-color:red;color:white'>One or more tests failed!<p>");
        writeOutput("<ol>");
        failures.forEach((string message) => {
            writeOutput("<li>#message#</li>");
        })
        writeOutput("</ol>");
    }
    else {
        writeOutput("<p style='background-color:green;color:white'>All passed!</p>")
    }
}
</cfscript>