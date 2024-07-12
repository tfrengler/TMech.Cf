<cfscript>

Selenium = new Selenium( expandPath("./SeleniumLibs") );
ChromeService = Selenium.ChromeDriverService().createDefaultService();

ChromeOptions = Selenium.ChromeOptions().init();
ChromeOptions.setBinary(createObject("java", "java.io.File").init("C:\Temp\Chromium\chrome.exe"));

writeOutput("<p>1: ChromeDriver without anything</p>");cfflush();
ChromeDriver = Selenium.ChromeDriver().init();
sleep(3000);
ChromeDriver.quit();

writeOutput("<p>2: ChromeDriver with service</p>");cfflush();
ChromeDriver = Selenium.ChromeDriver().init(ChromeService);
sleep(3000);
ChromeDriver.quit();

writeOutput("<p>3: ChromeDriver with options</p>");cfflush();
ChromeDriver = Selenium.ChromeDriver().init(ChromeOptions);
sleep(3000);
ChromeDriver.quit();

writeOutput("<p>4: ChromeDriver with service and options</p>");cfflush();
ChromeService = Selenium.ChromeDriverService().createDefaultService();
ChromeDriver = Selenium.ChromeDriver().init(ChromeService, ChromeOptions);
sleep(3000);
ChromeDriver.quit();

writeOutput("<p>5: RemoteWebdriver with service URL and options</p>");cfflush();
ChromeService = Selenium.ChromeDriverService().createDefaultService();
ChromeService.start();
ChromeDriver = Selenium.RemoteWebDriver().init(ChromeService.getUrl(), ChromeOptions);
sleep(3000);
ChromeDriver.quit();
ChromeService.stop();

writeOutput("<p>6: RemoteWebDriver builder with options and service instance</p>");cfflush();
ChromeService = Selenium.ChromeDriverService().createDefaultService();
ChromeDriver = Selenium.RemoteWebDriver()
        .builder()
        .addAlternative(ChromeOptions)
        .withDriverService(ChromeService)
        .build();
sleep(3000);
ChromeDriver.quit();

writeOutput("<p>7: RemoteWebDriver builder with options and service URL</p>");cfflush();
ChromeService = Selenium.ChromeDriverService().createDefaultService();
ChromeService.start();
ChromeDriver = Selenium.RemoteWebDriver()
        .builder()
        .addAlternative(ChromeOptions)
        .address(ChromeService.getUrl())
        .build();
sleep(3000);
ChromeDriver.quit();
ChromeService.stop();

</cfscript>