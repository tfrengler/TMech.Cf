<cfscript>
    writeOutput("<fieldset><legend>Should NOT throw</legend>")

    try {
        Assertions.Assert::ThatString(" x  ", Assertions.StringValue::IsNot().Nothing());
        writeOutput("<p>OK! Assertions.Assert::ThatString(' x  ', Assertions.StringValue::IsNot().Nothing());</p>");
    }
    catch (any error) {
        writeOutput("<p>Expected NOT to throw but it did</p>");
        writeDump(error.Message);
    }

    try {
        Assertions.Assert::ThatString("   ", Assertions.StringValue::Is().Nothing());
        writeOutput("<p>OK! Assertions.Assert::ThatString('   ', Assertions.StringValue::Is().Nothing())</p>");
    }
    catch (any error) {
        writeOutput("<p>Expected NOT to throw but it did</p>");
        writeDump(error.Message);
    }

    try {
        Assertions.Assert::ThatString("test", Assertions.StringValue::IsNot().EqualTo("nottest"));
        writeOutput("<p>OK! Assertions.Assert::ThatString('test', Assertions.StringValue::IsNot().EqualTo('nottest'))</p>");
    }
    catch (any error) {
        writeOutput("<p>Expected NOT to throw but it did</p>");
        writeDump(error.Message);
    }

    try {
        Assertions.Assert::ThatString("test", Assertions.StringValue::Is().EqualTo("test"));
        writeOutput("<p>OK! Assertions.Assert::ThatString('test', Assertions.StringValue::Is().EqualTo('test'))</p>");
    }
    catch (any error) {
        writeOutput("<p>Expected NOT to throw but it did</p>");
        writeDump(error.Message);
    }

    try {
        Assertions.Assert::ThatString("test", Assertions.StringValue::Is().Containing("es"));
        writeOutput("<p>OK! Assertions.Assert::ThatString('test', Assertions.StringValue::Is().Containing('es'))</p>");
    }
    catch (any error) {
        writeOutput("<p>Expected NOT to throw but it did</p>");
        writeDump(error.Message);
    }

    try {
        Assertions.Assert::ThatString("test", Assertions.StringValue::IsNot().Containing("x"));
        writeOutput("<p>OK! Assertions.Assert::ThatString('test', Assertions.StringValue::IsNot().Containing('x'))</p>");
    }
    catch (any error) {
        writeOutput("<p>Expected NOT to throw but it did</p>");
        writeDump(error.Message);
    }

    try {
        Assertions.Assert::ThatString("test", Assertions.StringValue::Is().StartingWith("te"));
        writeOutput("<p>OK! Assertions.Assert::ThatString('test', Assertions.StringValue::Is().StartingWith('te'))</p>");
    }
    catch (any error) {
        writeOutput("<p>Expected NOT to throw but it did</p>");
        writeDump(error.Message);
    }

    try {
        Assertions.Assert::ThatString("test", Assertions.StringValue::IsNot().StartingWith("tx"));
        writeOutput("<p>OK! Assertions.Assert::ThatString('test', Assertions.StringValue::IsNot().StartingWith('tx'))</p>");
    }
    catch (any error) {
        writeOutput("<p>Expected NOT to throw but it did</p>");
        writeDump(error.Message);
    }

    try {
        Assertions.Assert::ThatString("test", Assertions.StringValue::Is().EndingWith("st"));
        writeOutput("<p>OK! Assertions.Assert::ThatString('test', Assertions.StringValue::Is().EndingWith('st'))</p>");
    }
    catch (any error) {
        writeOutput("<p>Expected NOT to throw but it did</p>");
        writeDump(error.Message);
    }

    try {
        Assertions.Assert::ThatString("test", Assertions.StringValue::IsNot().EndingWith("xt"));
        writeOutput("<p>OK! Assertions.Assert::ThatString('test', Assertions.StringValue::IsNot().EndingWith('xt'))</p>");
    }
    catch (any error) {
        writeOutput("<p>Expected NOT to throw but it did</p>");
        writeDump(error.Message);
    }

    // ##################################################################################################################

    writeOutput("</fieldset>");
    writeOutput("<fieldset><legend>Should throw</legend>")

    try {
        Assertions.Assert::ThatString("   ", Assertions.StringValue::IsNot().Nothing());
        writeOutput("<p>Expected to throw but it did not</p>");
    }
    catch (TMech.Assertion.Failed error) {
        writeOutput("<p>");
        writeOutput("<div>OK!</div>");
        writeDump(error.Message);
        writeOutput("</p>");
    }

    try {
        Assertions.Assert::ThatString(" x  ", Assertions.StringValue::Is().Nothing());
        writeOutput("<p>Expected to throw but it did not</p>");
    }
    catch (TMech.Assertion.Failed error) {
        writeOutput("<p>");
        writeOutput("<div>OK!</div>");
        writeDump(error.Message);
        writeOutput("</p>");
    }

    try {
        Assertions.Assert::ThatString("test", Assertions.StringValue::IsNot().EqualTo("test"));
        writeOutput("<p>Expected to throw but it did not</p>");
    }
    catch (TMech.Assertion.Failed error) {
        writeOutput("<p>");
        writeOutput("<div>OK!</div>");
        writeDump(error.Message);
        writeOutput("</p>");
    }

    try {
        Assertions.Assert::ThatString("test", Assertions.StringValue::Is().EqualTo("nottest"));
        writeOutput("<p>Expected to throw but it did not</p>");
    }
    catch (TMech.Assertion.Failed error) {
        writeOutput("<p>");
        writeOutput("<div>OK!</div>");
        writeDump(error.Message);
        writeOutput("</p>");
    }

    try {
        Assertions.Assert::ThatString("test", Assertions.StringValue::Is().Containing("x"));
        writeOutput("<p>Expected to throw but it did not</p>");
    }
    catch (TMech.Assertion.Failed error) {
        writeOutput("<p>");
        writeOutput("<div>OK!</div>");
        writeDump(error.Message);
        writeOutput("</p>");
    }

    try {
        Assertions.Assert::ThatString("test", Assertions.StringValue::IsNot().Containing("es"));
        writeOutput("<p>Expected to throw but it did not</p>");
    }
    catch (TMech.Assertion.Failed error) {
        writeOutput("<p>");
        writeOutput("<div>OK!</div>");
        writeDump(error.Message);
        writeOutput("</p>");
    }

    try {
        Assertions.Assert::ThatString("test", Assertions.StringValue::Is().StartingWith("tx"));
        writeOutput("<p>Expected to throw but it did not</p>");
    }
    catch (TMech.Assertion.Failed error) {
        writeOutput("<p>");
        writeOutput("<div>OK!</div>");
        writeDump(error.Message);
        writeOutput("</p>");
    }

    try {
        Assertions.Assert::ThatString("test", Assertions.StringValue::IsNot().StartingWith("te"));
        writeOutput("<p>Expected to throw but it did not</p>");
    }
    catch (TMech.Assertion.Failed error) {
        writeOutput("<p>");
        writeOutput("<div>OK!</div>");
        writeDump(error.Message);
        writeOutput("</p>");
    }

    try {
        Assertions.Assert::ThatString("test", Assertions.StringValue::Is().EndingWith("sx"));
        writeOutput("<p>Expected to throw but it did not</p>");
    }
    catch (TMech.Assertion.Failed error) {
        writeOutput("<p>");
        writeOutput("<div>OK!</div>");
        writeDump(error.Message);
        writeOutput("</p>");
    }

    try {
        Assertions.Assert::ThatString("test", Assertions.StringValue::IsNot().EndingWith("st"));
        writeOutput("<p>Expected to throw but it did not</p>");
    }
    catch (TMech.Assertion.Failed error) {
        writeOutput("<p>");
        writeOutput("<div>OK!</div>");
        writeDump(error.Message);
        writeOutput("</p>");
    }

    writeOutput("</fieldset>");
</cfscript>