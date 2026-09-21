# Flutter CI/CD Proof of Concept (POC)

This project is a small **Flutter login app** used as a proof of concept (POC) to demonstrate a complete, real-world CI/CD pipeline. It is not meant to be a production app — the login logic is intentionally simple so the focus stays on the pipeline itself: how code gets built, tested, quality-checked, and packaged automatically every time it is pushed to GitHub.

## What This Project Demonstrates

The POC ties together three practices that a real software team would use together:

1. **Functional Testing** – Flutter widget tests (`test/widget_test.dart`), a pure unit test (`test/login_logic_test.dart`), Karate API tests (`karate_tests/`), and Cucumber (BDD) API tests (`cucumber_tests/`)
2. **Quality Gates** – SonarQube (`sonar-project.properties`)
3. **CI/CD Pipeline** – GitHub Actions (`.github/workflows/ci-cd.yml`)

## Key Terms (for anyone new to these tools)

| Term                                    | What it means                                                                                                                                                                                                               |
| --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **CI (Continuous Integration)**         | Automatically building and testing code every time someone pushes changes, so problems are caught immediately instead of later.                                                                                             |
| **CD (Continuous Delivery/Deployment)** | Automatically packaging (and optionally releasing) the app once it passes CI, so it's always ready to ship.                                                                                                                 |
| **GitHub Actions**                      | GitHub's built-in automation tool. You describe a pipeline in a `.yml` file, and GitHub runs it automatically on events like a `push` or `pull request`.                                                                    |
| **Flutter**                             | Google's UI toolkit for building apps from a single codebase (Android, iOS, web, desktop). This POC's app is written in Flutter/Dart.                                                                                       |
| **Unit Test**                           | A test that calls a plain function or class directly and checks its return value — no UI is rendered. Fast and isolated.                                                                                                    |
| **Widget Test**                         | A Flutter-specific automated test that renders part of the app's UI in memory and checks how it behaves (e.g., "does tapping this button show this message?").                                                              |
| **SonarQube / SonarCloud**              | A code-quality analysis tool. It scans source code for bugs, code smells, security issues, and test coverage, then reports a pass/fail "Quality Gate".                                                                      |
| **Karate**                              | A testing framework (built on Java) used here to test a backend API directly — sending HTTP requests and checking the responses — independent of the mobile app UI.                                                         |
| **Cucumber**                            | A classic BDD (Behavior-Driven Development) testing framework. Test scenarios are written in plain-English **Gherkin** syntax (`Given / When / Then`), and each line is backed by a matching Java "step definition" method. |
| **Gherkin**                             | The plain-English syntax (`Given`, `When`, `Then`, `And`) used to write BDD test scenarios in a `.feature` file, readable by both developers and non-technical people. Both Karate and Cucumber use it.                     |
| **RestAssured**                         | A Java library for calling and validating HTTP APIs in tests — used inside the Cucumber step definitions to send requests and check responses.                                                                              |
| **Maven**                               | A build/dependency tool for Java projects. It's used here to run both the Karate tests and the Cucumber tests (`mvn test`).                                                                                                 |
| **Code Coverage**                       | A percentage showing how much of the source code was actually executed by the automated tests. Reported here via `coverage/lcov.info`.                                                                                      |
| **Artifact (in CI/CD)**                 | A file produced by a pipeline run (e.g., a built APK or a test report) that gets saved so people can download it after the pipeline finishes.                                                                               |

## Project Structure

```text
cicd_poc/
├── lib/
│   ├── main.dart                    -> The Flutter login app (UI only)
│   └── login_logic.dart             -> Pure login validation logic (used by main.dart)
├── test/
│   ├── widget_test.dart             -> Widget tests (UI behaviour)
│   └── login_logic_test.dart        -> Pure unit tests (logic only, no UI)
├── karate_tests/
│   ├── pom.xml
│   └── src/test/java/
│       ├── features/login.feature
│       └── runners/LoginTestRunner.java
├── cucumber_tests/
│   ├── pom.xml
│   └── src/test/java/
│       ├── features/login.feature
│       ├── stepdefinitions/LoginSteps.java
│       └── runners/CucumberTestRunner.java
├── sonar-project.properties
├── pubspec.yaml
└── .github/workflows/ci-cd.yml
```

---

## Step-by-Step: Which Command to Run, and When

This is the exact order to follow, from a brand-new checkout of this project to a fully working local + GitHub setup. Each step says **what to run** and **why**.

### Step 1 — Confirm your tools are installed

```bash
flutter doctor
java -version
mvn -version
```

Run this once, at the very start. `flutter doctor` confirms Flutter is installed correctly. `java -version` and `mvn -version` confirm Java and Maven are installed (needed for the Karate and Cucumber tests). If any of these fail, install the missing tool before continuing.

### Step 2 — Get the Flutter project ready

```bash
flutter create .
```

Run this **only once**, and only if the `android/` and `ios/` folders are missing from the project (for example, after downloading just the source files without the native platform folders). This generates those folders without touching your existing `lib/`, `test/`, or `pubspec.yaml` files.

```bash
flutter pub get
```

Run this every time you open the project for the first time, and again any time `pubspec.yaml` changes or after running `flutter clean`. It downloads/links all Flutter package dependencies.

### Step 3 — Run the Flutter checks locally

```bash
flutter analyze
```

Run this to catch lint/style issues before committing. It doesn't run tests — it only checks code quality.

```bash
flutter test --coverage
```

Run this to execute **all** Dart test files in the `test/` folder — both `widget_test.dart` and `login_logic_test.dart` run automatically with this single command. It also produces a `coverage/lcov.info` file used later by SonarQube.

```bash
flutter build apk --debug
```

Run this to build an installable APK for manual testing on a device or emulator. The output file will be at:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

### Step 4 — Run the Karate API tests locally (optional)

```bash
cd karate_tests
mvn test
```

Run this any time you want to verify the backend API tests without waiting for GitHub Actions. The HTML report is generated at:

```test
karate_tests/target/karate-reports/karate-summary.html
```

### Step 5 — Run the Cucumber API tests locally (optional)

```bash
cd cucumber_tests
mvn test
```

Run this the same way as Karate, to verify the Cucumber/Gherkin-style API tests independently. Results are written to:

```test
cucumber_tests/target/surefire-reports/
```

### Step 6 — Set up Git and push to GitHub (first time only)

```bash
git init
git add .
git commit -m "Initial CI/CD POC setup"
git branch -M main
git remote add origin https://github.com/<your-username>/<your-repo>.git
git push -u origin main
```

Run this sequence **once**, from inside the project's root folder. After this first push, you only need `git add .`, `git commit -m "..."`, and `git push` for future changes — `git init` and `git remote add` are not repeated.

### Step 7 — Add the SonarCloud secrets on GitHub (first time only)

This isn't a terminal command — it's done on the GitHub website:

1. Go to your repository → **Settings** → **Secrets and variables** → **Actions**
2. Add a secret named `SONAR_TOKEN` with your SonarCloud token as the value
3. Add a second secret named `SONAR_HOST_URL` with the value `https://sonarcloud.io`

Do this once, before the first push that you want the `sonarqube-scan` job to succeed on. If these secrets are missing, the SonarQube job will fail, but the rest of the pipeline still runs.

### Step 8 — Let GitHub Actions run automatically

No command needed here — pushing to `main` or `develop` (Step 6, or any later `git push`) automatically triggers the pipeline. Watch it under your repository's **Actions** tab.

### Step 9 — Re-run or check the pipeline without pushing new code

If you only want to re-run the existing pipeline (for example, after fixing a GitHub secret), go to the **Actions** tab → open the latest run → click **"Re-run all jobs"**. No local command is needed for this.

### Step 10 — Clean up a broken local build (only when needed)

```bash
flutter clean
flutter pub get
```

Run `flutter clean` only if you're seeing strange build errors that don't make sense, or after upgrading Flutter/Gradle versions. It deletes generated build files (`build/`, `.dart_tool/`) but does **not** touch your source code or Git history. Always run `flutter pub get` again immediately afterward.

---

## Quick Reference Table

| When                               | Command                                                             |
| ---------------------------------- | ------------------------------------------------------------------- |
| First time setting up the project  | `flutter doctor`, `flutter create .` (if needed), `flutter pub get` |
| Before every commit                | `flutter analyze`, `flutter test --coverage`                        |
| To build an APK manually           | `flutter build apk --debug`                                         |
| To test the backend API manually   | `cd karate_tests && mvn test`                                       |
| To test the BDD scenarios manually | `cd cucumber_tests && mvn test`                                     |
| First time connecting to GitHub    | `git init`, `git remote add origin ...`, `git push -u origin main`  |
| Every time after that              | `git add .`, `git commit -m "..."`, `git push`                      |
| If the build looks broken          | `flutter clean` then `flutter pub get`                              |

---

## How the Pipeline Works (on GitHub Actions)

The pipeline is defined in `.github/workflows/ci-cd.yml` and runs automatically whenever code is pushed to the `main` or `develop` branches, or when a pull request targets `main`. It has 5 active jobs, plus a 6th job that is present but intentionally disabled:

```test
Code Push
   |
   v
[Job 1] test  -> flutter analyze + flutter test --coverage
   |
   v
[Job 2] build -> flutter build apk --debug + upload APK artifact
   |
   v
[Job 3] sonarqube-scan -> SonarQube/SonarCloud quality analysis
   |
   +-----------------------------------+
   v                                   v
[Job 4] karate-functional-tests       [Job 5] cucumber-functional-tests
   |                                   |
   +-----------------------------------+
   |
   v
[Job 6] Deploy (present in the file but commented out — not needed for this POC)
```

- **Job 1 – `test`**: Checks out the code, installs Flutter and Java, runs static analysis (`flutter analyze`), and runs all Dart tests with coverage (`flutter test --coverage`). The coverage report is uploaded as an artifact for later use by SonarQube.
- **Job 2 – `build`**: Runs only after `test` passes. Builds the debug APK and uploads it as a downloadable artifact.
- **Job 3 – `sonarqube-scan`**: Downloads the coverage report and sends the source code + coverage data to SonarQube/SonarCloud. Requires the `SONAR_TOKEN` and `SONAR_HOST_URL` repository secrets (see Step 7 above).
- **Job 4 – `karate-functional-tests`**: Runs the Karate API tests using Maven.
- **Job 5 – `cucumber-functional-tests`**: Runs the Cucumber (Gherkin) API tests using Maven. Jobs 4 and 5 both only depend on Job 3, so GitHub Actions runs them in parallel.
- **Job 6 – `deploy`** _(disabled)_: A placeholder showing where a real deployment step (e.g., to Firebase App Distribution or the Play Store) would go. Left commented out because publishing an app isn't part of this POC's scope.

> **Why both Karate and Cucumber?** They test the same API on purpose, to show two different functional-testing styles side by side: Karate uses its own built-in DSL (no step-definition code needed), while Cucumber is the more traditional BDD approach where every Gherkin line maps to a Java method you write yourself. A real project would normally pick just one.

## Notes

- The Karate and Cucumber tests both call `reqres.in`, a free public mock API, purely for this POC. Point `login.feature` (in both `karate_tests/` and `cucumber_tests/`) at your real backend URL when applying this setup to an actual project.
- If SonarQube isn't set up yet, the `sonarqube-scan` job can simply be removed from the workflow file, or disabled with `if: false`, without breaking the rest of the pipeline.
- The `deploy` job is intentionally left commented out — the full pipeline (build, test, quality check, API test) can be verified without needing a Play Store account.
