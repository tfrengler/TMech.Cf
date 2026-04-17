# TMech.Cf

An opinionated test automation boostrapping/utility library built for **Coldfusion/CFML**, specifically targeting **Lucee**. The last part really must be *emphasized*. There are a lot of things in this that makes it unusable for **ACF** or any other CFML distribution.

Use it for personal or professional projects, fork it and make your own changes or use a learning exercise to write your own tools. If it helps someone else in some capacity then that is awesome.

**IMPORTANT NOTE:** The project is provided here in public **as-is**. It is open-source but not open-*contribution*. Patches, feature- and change requests are not accepted. If there are bugs I will try to fix them when my time allows. Although is a personal (hobby) project much of this currently is or has been used professionally throughout my career as a test automation engineer.

## TESTS:

Almost everything is covered by functional/regression tests so that I can be (reasonably) sure that nothing I change or fix will break stuff. Most of these tests are quite technically involved since they require a local install of all supported browsers and their webdriver binaries, as well as a Selenium Grid server. I try to automate as much as I can but some things (particularly all the variations of starting a WebdriverContext) are better off being manually tested.

All the tests are in the **tests**-subfolder which you can safely ignore or delete.

**Tested against**:
- Lucee 6.1.1.118: **OK**
- Lucee 6.2.1.122: **NOK (see below)**
- Lucee 7.0.0.202+: *UNTESTED*

*NOTE:* There seems to something amiss with instantiating Java-objects in Lucee 6.2 so if you encounter exceptions about Lucee not being able to instantiate or resolve Java-classes then this is likely the issue! It especially seems to have issues with nested classes (org.openqa.selenium.remote.RemoteWebDriver$ByteBuddy comes up frequently). Use Lucee 6.1 for now.

## CONTENTS:

This library currently consists of these parts:
1. ChromeProvider
1. WebdriverContext and WebdriverBuilder
1. Assertion-library
## 1: ChromeProvider

A tool that can auto-download the latest stable **Chrome for Testing** version for you. Useful for automatically keeping a local browser (and its webdriver binary) up to date for testing against. It's cross-platform and works on Win and Linux (only for 64-bit).

*EXAMPLES:*

```cfc
provider = new ChromeProvider('path-to-desired-folder');

// Download latest version

wasDownloaded = provider.DownloadLatestVersion("win64");
writeDump("Was Chrome updated? #wasDownloaded#");

// Check the latest version available online

writeDump("Latest version: #provider.GetLatestAvailableVersion()#");
```

## 2: WebdriverContext and WebdriverBuilder

The WebdriverContext is a wrapper around the underlying Java-webdriver and contains the logic for starting a browser. Since starting a browser can be somewhat complex there's the accompanying WebdriverBuilder which features a fluent API for setting up a webdriver instance.

### Installation:

Before you get started you need the Selenium Java-files. Go to the website (https://www.selenium.dev/downloads/) and download the Java-bindings. There are two options now depending on how you want to use this library:

**1:** If you chose to use the **Application.cfc** that's included in this library then you need to do very little. Unzip the contents of the Java-bindings into a folder called **SeleniumLibs** inside the root folder (where Application.cfc lives).
A singleton instance of **Selenium.cfc** will be instantiated and registed on application startup and put in the **application**-scope.

**2:** If you chose to use your own setup then you will have to manage the lifetime of **Selenium.cfc** yourself. First unzip the contents of the Java-bindings into a folder of your choice. Instantiate **Selenium.cfc** with the folder where the Java-bindings are located as argument for the constructor. Then somewhere in your startup routine call the static method **WebdriverBuilder::RegisterSelenium** with your Selenium-instance.

*EXAMPLES:*

```cfc
// Assuming you are managing Selenium yourself and extracted the Java-binding to C:\SeleniumJavaBindings\
selenium = new Utils.Selenium("C:\SeleniumJavaBindings\");

// Register Selenium-bindings globally. All WebdriverBuilder-instances will use instance this going forward
Utils.WebdriverBuilder::RegisterSelenium(selenium);

// NOTE: If you use the included Application.cfc then two steps above can be skipped.

// Starting Chrome locally (local drivers are implicitly headless)

context = Utils.WebdriverBuilder::CreateLocal("CHROME")
            .WithWindowSize(1920, 1080)
            .Initialize();

// Using 'Chrome for Testing' locally using explicit binary location

context = Utils.WebdriverBuilder::CreateLocal("CHROME")
            .WithWindowSize(1920, 1080)
            .WithBrowserBinaryLocatedAt("C:\chrome-for-testing\chrome.exe")
            .Initialize();

// Starting Chrome in GUI-mode (useful for development and debugging)
// First start the webdriver binary manually on your machine (might run on http://localhost:56774, port is randomized)

context = Utils.WebdriverBuilder::CreateRemote("CHROME", "http://localhost:56774")
            .ThatRunsFullScreen()
            .Initialize();

// Starting Chrome on a remote Selenium Grid server in headless mode with a standard desktop resolution

context = Utils.WebdriverBuilder::CreateRemote("CHROME", "http://my-selenium-grid-server:12345")
            .ThatRunsHeadless(new Models.Dimension(1920, 1080))
            .Initialize();

// Start using Selenium via the Java-webdriver (navigate to some page)
context.Driver().get("https://www.somewebsite.com/");

// Fetch element and click it
element = context.Driver().findElement(selenium.By().cssSelector("#IdOfSomeElement"));
element.click();

// Make sure you shutdown cleanly or you will have lingering browser/webdriver processes

context.onDestroy();
// or
context.Driver().quit();

//The former is safer and should not throw unless 'context' itself is null or invalid
```

## 3: Assertion-library

A custom assertion library written in the NUnit-style. It currently covers:
- Arrays
- Numbers
- Strings
- Structs
- Exception thrown or not thrown
- Strict type checks, not allowing for natural CFML coercion ("42" != 42)

Not the most feature-rich (yet?) but a solid basis none the less in a style that I personnally like a lot. It may not be idiomatic of CFML to by default be the most strict about coercion and casing but I like strictness as a default.

*EXAMPLES*:

```cfc
// NUMBERS

// Pass:
Assertions.Assert::That(
    2,
    Assertions.NumberValue::Is().EqualTo(2)
);

// ANY (Exceptions, type checks etc)

Assertions.Assert::That(
    () => { throw("I throw!") },
    Assertions.AnyValue::Is().Throwing()
);

Assertions.Assert::That(
    () => true,
    Assertions.AnyValue::IsNot().Throwing()
);

// The type checks are strict
// Fail:
Assertions.Assert::That("42", Assertions.AnyValue::Is().Numeric());

// STRINGS

// Fail:
Assertions.Assert::That("", Assertions.StringValue::IsNot().Nothing());

// String-asserts can be configured to ignore case
// Pass:
Assertions.Assert::That(
    "test",
    Assertions.StringValue::Is().IgnoringCase().EqualTo("TEST")
);

// ARRAYS

// Pass:
Assertions.Assert::That(
    [1,2,3],
    Assertions.ArrayValue::Is().SequenceEqualTo([1,2,3])
);

// Asserting against an array with same values out of sequence
// Pass:
Assertions.Assert::That(
    [5,1,3],
    Assertions.ArrayValue::Is().SimilarTo([1,3,5])
);

// For more complicated checks a predicate can be used
// Pass:
Assertions.Assert::That(
    [1,2],
    Assertions.ArrayValue::Is().SatisfiedByAll((x) => arguments.x < 3)
);
```