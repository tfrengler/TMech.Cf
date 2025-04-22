# TMech.Cf

What is this? Well, it's a boostrapping/utility library built around Selenium for **Coldfusion**. It's a direct port of utilities and services that I have written for my work as a test automation engineer across various projects and collected in one place so it's easier to maintain and migrate them. Use it for personal or professional projects, fork it and make your own changes or use a learning exercise to write your own tools. If it helps someone else in some capacity then that is great.

The project is provided here in public **as-is**. It is open-source but not open-contribution. Patches, pull requests, feature- and change requests are not accepted.
## TESTS:

Almost everything is covered by functional regression/unit tests so that I can be (reasonably) sure that nothing I change or fix will break stuff. Most of these tests are quite technically involved since they require a local install of all supported browsers and their webdriver binaries, as well as a Selenium Grid server. Therefore they have hardcoded values that only work on my machine.

## CONTENTS:

This library currently consists of these parts:
1. ChromeProvider
1. WebdriverContext and WebdriverBuilder
## 1: ChromeProvider

Tools that can auto-download the latest stable **Chrome for Testing** version for you. This were created so that we could automatically keep a local browser (and its webdriver binary) up to date for testing against. It's cross-platform and works on Win and Linux (only for 64-bit).

## 2: WebdriverContext and WebdriverBuilder

The WebdriverContext is a wrapper around the underlying Java-webdriver and contains the logic for starting a browser.
Since starting a browser can be somewhat complex there's the accompanying WebdriverBuilder which features a fluent API
for setting up a webdriver instance.

### Installation:

Before you get started you need Selenium. Go to the website (https://www.selenium.dev/downloads/) and download the Java-bindings.
Unzip the contents into a folder called **SeleniumLibs** inside the root folder (where Application.cfc lives).
A singleton instance of **Selenium.cfc** will be instantiated on application startup and put in the **application**-scope.

*EXAMPLES:*

```cfc
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
// First start the webdriver binary manually on your machine (might run on http://localhost:56774)

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
selenium = handle_to_selenium_component;
element = context.Driver().findElement(selenium.By().cssSelector("#IdOfSomeElement"));
element.click();

// Make sure you shutdown cleanly or you will have lingering browser/webdriver processes

context.onDestroy();
// or
context.Driver().quit();

//The former is safer and should not throw unless 'context' itself is null or invalid
```