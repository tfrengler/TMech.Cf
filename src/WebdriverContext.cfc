/**
 * Component that represents the context of a Selenium webdriver (the class that represents and 'drives' the browser interaction).
 * Contains the logic for managing the lifetime of a webdriver along with its state and configuration.
 */
component displayname="WebdriverContext" modifier="final" output="false" accessors="false" persistent="true" {

    // PUBLIC
    property name="Browser"         type="string" getter="true" setter="false";
    property name="Selenium"        type="string" getter="true" setter="false";
    property name="IsRemote"        type="boolean" getter="true" setter="false";
    property name="BrowserBinary"   type="string" getter="true" setter="false";
    property name="RemoteServerUrl" type="string" getter="true" setter="false";
    property name="DownloadsFolder" type="string" getter="true" setter="false";

    // PRIVATE
    property name="IsDisposed"      type="boolean" getter="false" setter="false";
    property name="Selenium"        type="string" getter="false" setter="false";
    property name="Webdriver"       type="any" getter="false" setter="false";
    /* The above is a Java-object. If IsRemote = false then it is one of these (depending on Browser):
        - org.openqa.selenium.chrome.ChromeDriver
        - org.openqa.selenium.firefox.FirefoxDriver
        - org.openqa.selenium.edge.EdgeDriver
    * If IsRemote = true then it is: org.openqa.selenium.remote.RemoteWebDriver
    */

    private WebdriverContext function Init(
        required string browser,
        required boolean isRemote,
        string browserBinary = "",
        any driverService = 0,
        string remoteServerUrl = "")
    {

        if (!IsValidBrowser(browser)) {
            throw("Error instantiating WebdriverContext. Argument 'browser' is invalid: #arguments.browser#. Valid values are #variables.ValidBrowsers#");
        }

        variables.Selenium = session.Selenium;
        variables.Browser = arguments.browser;
        return this;
    }

    /* STATIC FUNCTIONS */

    public static WebdriverContext function CreateLocal(required string browser, string browserBinary = "") {
        return new WebdriverContext(arguments.browser, false);
    }

    public static WebdriverContext function CreateLocalWithService(required string browser, required any driverService, string browserBinary = "") {
        return new WebdriverContext(arguments.browser, false);
    }

    public static WebdriverContext function CreateRemote(required string browser, required string remoteServerUrl) {
        return new WebdriverContext(arguments.browser, true);
    }

    public static string function GetValidBrowsers() { return "CHROME,FIREFOX,EDGE"; }

    public static boolean function IsValidBrowser(required string browser) {
        return listFind(GetValidBrowsers(), arguments.browser) != 0;
    }
}