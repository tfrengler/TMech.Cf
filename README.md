# TMech.Cf

What is this? Well, it's a boostrapping/utility library built around Selenium for **Coldfusion**. It's a direct port of utilities and services that I have written for my work as a test automation engineer across various projects and collected in one place so it's easier to maintain and migrate them. Use it for personal or professional projects, fork it and make your own changes or use a learning exercise to write your own tools. If it helps someone else in some capacity then that is great.

The project is provided here in public **as-is**. It is open-source but not open-contribution. Patches, pull requests, feature- and change requests are not accepted.
## TESTS:

Almost everything is covered by functional regression/unit tests so that I can be (reasonably) sure that nothing I change or fix will break stuff. Most of these tests are quite technically involved since they require a local install of all supported browsers and their webdriver binaries, as well as a Selenium Grid server. Therefore they have hardcoded values that only work on my machine.

## CONTENTS:

It consists of these bits:
1. ChromeProvider
1. WebdriverContext
## 1: ChromeProvider

Tools that can auto-download the latest stable **Chrome for Testing** version for you. This were created so that we could automatically keep a local browser (and its webdriver binary) up to date for testing against. It's cross-platform and works on Win and Linux (only for 64-bit).

## 3: WebdriverContext

WIP