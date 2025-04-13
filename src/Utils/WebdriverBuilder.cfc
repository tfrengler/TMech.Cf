/**
 * A utility for constructing a WebdriverContext using a fluent API
 */
component displayname="WebdriverBuilder" modifier="final" output="false" accessors="false" persistent="true"
{
    // PRIVATE
    property name="IsRemote"         type="boolean" getter="false" setter="false";
    property name="IsHeadless"       type="boolean" getter="false" setter="false";
    property name="IsFullscreen"     type="boolean" getter="false" setter="false";
    property name="WindowSize"       type="struct" getter="false" setter="false"; // x | y
    property name="DriverService"    type="any" getter="false" setter="false"; // org.openqa.selenium.remote.service.DriverService
    property name="BrowserBinary"    type="string" getter="false" setter="false";
    property name="DownloadFolder"   type="string" getter="false" setter="false";
    property name="Browser"          type="string" getter="false" setter="false";
    property name="RemoteServerUrl"  type="string" getter="false" setter="false";
    property name="BrowserArguments" type="array" getter="false" setter="false";

    private WebdriverBuilder function Init(required string browser, string remoteServerUrl = "") {
        if (arguments.browser.len() == 0) {
            throw("Argument 'browser' is required but was empty");
        }

        variables.IsRemote = false;
        variables.IsHeadless = false;
        variables.IsFullscreen = false;
        variables.WindowSize = {x: 0, y: 0};
        variables.BrowserBinary = "";
        variables.DownloadFolder = "";

        variables.Browser = arguments.browser;
        variables.RemoteServerUrl = arguments.remoteServerUrl;

        return this;
    }

    public static WebdriverBuilder function CreateLocal(required string browser) {
        return new WebdriverBuilder(arguments.browser);
    }

    public static WebdriverBuilder function CreateRemote(required string browser, required string remoteServerUrl) {
        if (arguments.remoteServerUrl.len() == 0) {
            throw("Argument 'remoteServerUrl' is required but was empty");
        }
        return new WebdriverBuilder(arguments.browser, arguments.remoteServerUrl);
    }

    private void function ThrowOnLocalOnly() {
        if (variables.IsRemote) {
            throw("This method can only be called on a builder used to create a local webdriver");
        }
    }

    // Remote and local

    public WebdriverBuilder function ThatRunsHeadless() {
        variables.IsHeadless = true;
        return this;
    }

    public WebdriverBuilder function ThatRunsFullScreen() {
        variables.IsFullscreen = true;
        return this;
    }

    public WebdriverBuilder function WithWindowSize(required numeric width, required numeric height) {

        if (arguments.width <= 0 || arguments.height <= 0) {
            throw("Argument width or height is equal to or less than 0 (x: #arguments.width# | y: #arguments.height#)");
        }

        variables.WindowSize = {x: arguments.width, y: arguments.height};
        return this;
    }

    public WebdriverBuilder function WithBrowserArguments(required array arguments) {
        variables.BrowserArguments = arguments.arguments;
        return this;
    }

    // Local only
    public WebdriverBuilder function UsingDriverService(required any service) {
        ThrowOnLocalOnly();

        // if (!isInstanceOf(arguments.service, "org.openqa.selenium.remote.service.DriverService")) {
        //     throw("Expected argument 'service' to be an instance of 'org.openqa.selenium.remote.service.DriverService'");
        // }

        variables.DriverService = arguments.service;
        return this;
    }

    public WebdriverBuilder function WithBrowserBinaryLocatedAt(required string absolutePathToExecutable) {
        ThrowOnLocalOnly();

        if (!fileExists(arguments.absolutePathToExecutable)) {
            throw("The file in argument 'absolutePathToExecutable' does not exist: #arguments.absolutePathToExecutable#");
        }

        variables.BrowserBinary = arguments.absolutePathToExecutable;
        return this;
    }

    public WebdriverBuilder function WithDownloadFolderLocatedAt(required string absolutePathToFolder) {
        ThrowOnLocalOnly();

        if (!directoryExists(arguments.absolutePathToFolder)) {
            throw("The folder in argument 'absolutePathToFolder' does not exist: #arguments.absolutePathToFolder#");
        }

        variables.DownloadFolder = arguments.absolutePathToFolder;
        return this;
    }

    // Final

    public Models.WebdriverContext function Initialize() {
        // TODO
    }
}