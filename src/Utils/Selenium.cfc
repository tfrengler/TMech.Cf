/**
 * @hint Component representing Selenium. Serves as a helper interface for resolving and getting references to underlying Selenium Java classes, types, enums etc.
 */
component displayname="Selenium" modifier="final" output="false" accessors="false" persistent="true" {

    property name="Jars" type="array" getter="false" setter="false";

    public Selenium function Init(required string pathToSeleniumJarFolder ) {

        if(directoryExists(arguments.pathToSeleniumJarFolder) == false)
        {
            throw("Error instantiating Selenium-component. The folder in 'pathToSeleniumJarFolder' does not exist: " & arguments.pathToSeleniumJarFolder);
        }

        var SeleniumJars = directoryList(pathToSeleniumJarFolder, false, "path", "*.jar");
        if (SeleniumJars.len() == 0)
        {
            throw("Error instantiating Selenium-component. The folder in parameter 'pathToSeleniumJarFolder' exist but appears to be empty (expected jar-files): " & arguments.pathToSeleniumJarFolder);
        }

        variables.Jars = SeleniumJars;

        variables.ProxyType = createObject("java", "org.openqa.selenium.Proxy$ProxyType", variables.Jars);
        variables.By = createObject("java", "org.openqa.selenium.By", variables.Jars);
        variables.ScreenshotOutputType = createObject("java", "org.openqa.selenium.OutputType", variables.Jars);

        return this;
    }

    /**
     * @hint Tests whether an object is a Java-object and optionally whether it is derived from - or is a specific - Java-object.
     *
     * @object          The object to test.
     * @javaClassName   Optional. The name of the Java-class you expect arguments.object to be.
     * @includeDerived  Optional. Determines whether javaClassName should match any derived classes as well or just the concrete class of the object itself.
     */
    public static boolean function isJavaObject(required any object, string javaClassName = "", boolean includeDerived = true) output = true
    {
        if (isNull(arguments.object)) return false;

        if (
            isSimpleValue(arguments.object) is true ||
            isArray(arguments.object) is true
        ) {
            return false;
        }

        arguments.javaClassName = isNull(arguments.javaClassName) ? "" : trim(arguments.javaClassName);
        var metadata = getMetadata(arguments.object);
        var isJavaObject = metadata.getClass().getName() == "java.lang.Class";
        var mustBeSpecificClass = arguments.javaClassName.len() > 0;

        if (!isJavaObject) {
            return false;
        }

        if (!mustBeSpecificClass) {
            return true;
        }

        var currentJavaClass = arguments.object.getClass();
        var actualClassName = currentJavaClass.getName();

        while(true) {
            if (actualClassName == arguments.javaClassName) {
                return true;
            }

            if (!arguments.includeDerived) {
                break;
            }

            currentJavaClass = currentJavaClass.getSuperClass();

            if (isNull(currentJavaClass)) {
                return false;
            }

            actualClassName = currentJavaClass.getName();
        }

        return false;
    }

    // Enums, interfaces and static classes go here
    property name="ProxyType"               type="org.openqa.selenium.Proxy$ProxyType" getter="false" setter="false";
    property name="By"                      type="org.openqa.selenium.By" getter="false" setter="false";
    property name="ScreenshotOutputType"    type="org.openqa.selenium.OutputType" getter="false" setter="false";

    public any function ProxyType() output = false {
        return variables.ProxyType;
    }

    public any function By() output = false {
        return variables.By;
    }

    public any function ScreenshotOutputType() output = false {
        return variables.ScreenshotOutputType;
    }

    // Functions return standard classes but they are just references and the caller has to call init() on them.
    // The exceptions are classes with a single constructor. If the single constructor requires arguments then they are implemented by the functions here.
    public any function FirefoxDriverService() output = false {
        return createObject("java", "org.openqa.selenium.firefox.GeckoDriverService", variables.Jars);
    }

    public any function FirefoxOptions() output = false {
        return createObject("java", "org.openqa.selenium.firefox.FirefoxOptions", variables.Jars);
    }

    public any function FirefoxDriver() output = false {
        return createObject("java", "org.openqa.selenium.firefox.FirefoxDriver", variables.Jars);
    }

    public any function ChromeDriverService() output = false {
        return createObject("java", "org.openqa.selenium.chrome.ChromeDriverService", variables.Jars);
    }

    public any function ChromeDriverServiceBuilder() output = false {
        return createObject("java", "org.openqa.selenium.chrome.ChromeDriverService$Builder", variables.Jars);
    }

    public any function ChromeOptions() output = false {
        return createObject("java", "org.openqa.selenium.chrome.ChromeOptions", variables.Jars);
    }

    public any function ChromeDriver() output = false {
        return createObject("java", "org.openqa.selenium.chrome.ChromeDriver", variables.Jars);
    }

    public any function Proxy() output = false {
        return createObject("java", "org.openqa.selenium.Proxy", variables.Jars);
    }

    public any function RemoteWebDriverBuilder() output = false {
        return createObject("java", "org.openqa.selenium.remote.RemoteWebDriverBuilder", variables.Jars);
    }

    public any function RemoteWebDriver() output = false {
        return createObject("java", "org.openqa.selenium.remote.RemoteWebDriver", variables.Jars);
    }

    public any function Dimension(required numeric width, required numeric height) output = false {
        return createObject("java", "org.openqa.selenium.Dimension", variables.Jars).init(width, height);
    }

    public any function LocalFileDetector() output = false {
        return createObject("java", "org.openqa.selenium.remote.LocalFileDetector", variables.Jars);
    }

    /**
     * @hint Returns a handle to a Java-object from the Selenium-packages. Returns an uninitialized handle that you must call init() on yourself.
     *
     * @javaObject The full name of the java-object to create a handle for.
     */
    public any function GetHandle(required string javaObject) output = false {
        return createObject("java", arguments.javaObject, variables.Jars);
    }
}