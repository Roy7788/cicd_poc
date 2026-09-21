# Flutter CI/CD Proof of Concept (POC)

This project is a small **Flutter login app** used as a proof of concept (POC) to demonstrate a complete, real-world CI/CD pipeline. It is not meant to be a production app — the login logic is intentionally simple so the focus stays on the pipeline itself: how code gets built, tested, quality-checked, and packaged automatically every time it is pushed to GitHub.

## What This Project Demonstrates

The POC ties together three practices that a real software team would use together:

1. **Functional Testing** – Flutter widget tests (`test/widget_test.dart`), Karate API tests (`karate_tests/`), and Cucumber (BDD) API tests (`cucumber_tests/`)
2. **Quality Gates** – SonarQube (`sonar-project.properties`)
3. **CI/CD Pipeline** – GitHub Actions (`.github/workflows/ci-cd.yml`)

## Key Terms (for anyone new to these tools)

| Term | What it means |
|---|---|
| **CI (Continuous Integration)** | Automatically building and testing code every time someone pushes changes, so problems are caught immediately instead of later. |
| **CD (Continuous Delivery/Deployment)** | Automatically packaging (and optionally releasing) the app once it passes CI, so it's always ready to ship. |
| **GitHub Actions** | GitHub's built-in automation tool. You describe a pipeline in a `.yml` file, and GitHub runs it automatically on events like a `push` or `pull request`. |
| **Flutter** | Google's UI toolkit for building apps from a single codebase (Android, iOS, web, desktop). This POC's app is written in Flutter/Dart. |
| **Widget Test** | A Flutter-specific automated test that renders part of the app's UI in memory and checks how it behaves (e.g., "does tapping this button show this message?"). |
| **SonarQube / SonarCloud** | A code-quality analysis tool. It scans source code for bugs, code smells, security issues, and test coverage, then reports a pass/fail "Quality Gate". |
| **Karate** | A testing framework (built on Java) used here to test a backend API directly — sending HTTP requests and checking the responses — independent of the mobile app UI. |
| **Cucumber** | A classic BDD (Behavior-Driven Development) testing framework. Test scenarios are written in plain-English **Gherkin** syntax (`Given / When / Then`), and each line is backed by a matching Java "step definition" method. Used here (`cucumber_tests/`) to test the same login API in a more explicit, step-by-step style. |
| **Gherkin** | The plain-English syntax (`Given`, `When`, `Then`, `And`) used to write BDD test scenarios in a `.feature` file, readable by both developers and non-technical people. Both Karate and Cucumber use it. |
| **RestAssured** | A Java library for calling and validating HTTP APIs in tests — used inside the Cucumber step definitions to send requests and check responses. |
| **JUnit 5 / Platform Suite** | The standard Java testing framework. Here it's used to discover and run the Cucumber feature files as part of `mvn test`. |
| **Maven** | A build/dependency tool for Java projects. It's used here to run both the Karate tests and the Cucumber tests (`mvn test`). |
| **Code Coverage** | A percentage showing how much of the source code was actually executed by the automated tests. Reported here via `coverage/lcov.info`. |
| **Artifact (in CI/CD)** | A file produced by a pipeline run (e.g., a built APK or a test report) that gets saved so people can download it after the pipeline finishes. |

## Project Structure

```
cicd_poc/
├── lib/main.dart                    -> The Flutter login app itself
├── test/widget_test.dart            -> Functional (widget) tests for the app's UI
├── karate_tests/
│   ├── pom.xml                      -> Maven project config for the Karate tests
│   └── src/test/java/
│       ├── features/login.feature   -> Karate API test scenarios (plain-English test steps)
│       └── runners/LoginTestRunner.java  -> Tells JUnit/Maven how to run the .feature file
├── cucumber_tests/
│   ├── pom.xml                      -> Maven project config for the Cucumber tests
│   └── src/test/java/
│       ├── features/login.feature   -> Cucumber (Gherkin) API test scenarios
│       ├── stepdefs/LoginSteps.java -> Java code implementing each Gherkin step (via RestAssured)
│       └── runners/CucumberTestRunner.java -> JUnit 5 runner that discovers and runs the feature file
├── sonar-project.properties         -> SonarQube/SonarCloud scan configuration
├── pubspec.yaml                     -> Flutter project & dependency definitions
└── .github/workflows/ci-cd.yml      -> The GitHub Actions pipeline definition
```

## The App Itself

`lib/main.dart` contains a single-screen login form (username + password fields and a login button). The logic is deliberately simple:

- Empty fields → shows "Username and password required"
- Wrong username/password → shows "Invalid credentials"
- Correct credentials (`rahul` / `test123`) → shows "Login successful"

This simplicity is intentional: the app exists to *give the pipeline something to build and test*, not to be a real product.

## How the Pipeline Works

The pipeline is defined in `.github/workflows/ci-cd.yml` and runs automatically whenever code is pushed to the `main` or `develop` branches, or when a pull request targets `main`. It has 4 active jobs, plus a 5th job that is present but intentionally disabled:

```
Code Push
   |
   v
[Job 1] Flutter build + flutter analyze + flutter test --coverage + APK build
   |
   v
[Job 2] SonarQube scan -> Quality Gate check
   |
   +-----------------------------------+
   v                                   v
[Job 3] Karate functional/API tests   [Job 4] Cucumber functional/API tests
   |                                   |
   +-----------------------------------+
   |
   v
[Job 5] Deploy (present in the file but commented out — not needed for this POC)
```

**Job 1 – `flutter-test`**: Checks out the code, installs Flutter and Java, runs static analysis (`flutter analyze`), runs the widget tests with coverage (`flutter test --coverage`), builds a debug APK, and uploads both the APK and the coverage report as downloadable artifacts.

**Job 2 – `sonarqube-scan`**: Downloads the coverage report from Job 1 and sends the source code + coverage data to SonarQube/SonarCloud for analysis. This step needs two GitHub repository secrets to work: `SONAR_TOKEN` and `SONAR_HOST_URL`.

**Job 3 – `karate-functional-tests`**: Runs the Karate API tests using Maven. These tests hit a live API and check the responses, independent of the Flutter app.

**Job 4 – `cucumber-functional-tests`**: Runs the Cucumber (Gherkin) API tests using Maven. It exercises the exact same login API as the Karate job, but written in the classic Cucumber style — plain-English `.feature` steps backed by Java step-definition methods. Job 3 and Job 4 both only depend on Job 2, so GitHub Actions runs them in parallel.

**Job 5 – `deploy`** *(disabled)*: A placeholder showing where a real deployment step (e.g., to Firebase App Distribution or the Play Store) would go. It's left commented out because publishing an app isn't part of this POC's scope.

> **Why both Karate and Cucumber?** They test the same API on purpose, to show two different functional-testing styles side by side: Karate uses its own built-in DSL (no step-definition code needed), while Cucumber is the more traditional BDD approach where every Gherkin line maps to a Java method you write yourself. A real project would normally pick just one.

## Running Things Locally

### 1. Flutter app and tests

```bash
flutter pub get
flutter analyze
flutter test --coverage
flutter build apk --debug
```

The built APK will be at: `build/app/outputs/flutter-apk/app-debug.apk`

### 2. Karate API tests

```bash
cd karate_tests
mvn test
```

The test report will be at: `karate_tests/target/karate-reports/karate-summary.html`

### 3. Cucumber API tests

```bash
cd cucumber_tests
mvn test
```

The test report will be at: `cucumber_tests/target/cucumber-reports/cucumber.html`

### 4. SonarQube scan (requires a running SonarQube server)

```bash
sonar-scanner \
  -Dsonar.projectKey=flutter-cicd-poc \
  -Dsonar.sources=lib \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=YOUR_SONAR_TOKEN
```

## Running It on GitHub Actions

1. Push this entire project folder to a GitHub repository.
2. If you want the SonarQube job to run, add these two repository secrets under **Settings → Secrets and variables → Actions**:
   - `SONAR_TOKEN`
   - `SONAR_HOST_URL`
3. Push to the `main` or `develop` branch — the pipeline will run automatically under the **Actions** tab.

## Notes

- The Karate and Cucumber tests both call `reqres.in`, a free public mock API, purely for this POC. Point `login.feature` (in both `karate_tests/` and `cucumber_tests/`) at your real backend URL when applying this setup to an actual project.
- If SonarQube isn't set up yet, the `sonarqube-scan` job can simply be removed from the workflow file, or disabled with `if: false`, without breaking the rest of the pipeline.
- The `deploy` job is intentionally left commented out — the full pipeline (build, test, quality check, API test) can be verified without needing a Play Store account.
