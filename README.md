# Flutter CI/CD POC

Ye POC 3 cheezein demonstrate karta hai:

1. **Functional Testing** – Flutter widget tests (`test/widget_test.dart`) aur Karate API tests (`karate_tests/`)
2. **Quality Gates** – SonarQube (`sonar-project.properties`)
3. **CI/CD Pipeline** – GitHub Actions (`.github/workflows/ci-cd.yml`)

Play Store deployment POC mein include nahi hai — sirf build + test + quality-check tak pipeline hai.

## Folder Structure

```
flutter-poc/
├── lib/main.dart                 -> Simple login app
├── test/widget_test.dart         -> Functional tests (Flutter)
├── karate_tests/
│   ├── pom.xml
│   └── src/test/java/
│       ├── features/login.feature   -> Karate API test scenarios
│       └── runners/LoginTestRunner.java
├── sonar-project.properties      -> SonarQube config
├── pubspec.yaml
└── .github/workflows/ci-cd.yml   -> Full CI/CD pipeline
```

## Local mein kaise chalayein

### 1. Flutter app aur tests
```bash
flutter pub get
flutter analyze
flutter test --coverage
flutter build apk --debug
```
APK yaha milega: `build/app/outputs/flutter-apk/app-debug.apk`

### 2. Karate functional/API tests
```bash
cd karate_tests
mvn test
```
Report yaha milegi: `karate_tests/target/karate-reports/karate-summary.html`

### 3. SonarQube (local scan ke liye SonarQube server chahiye)
```bash
sonar-scanner \
  -Dsonar.projectKey=flutter-cicd-poc \
  -Dsonar.sources=lib \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=YOUR_SONAR_TOKEN
```

## GitHub Actions mein chalane ke liye

1. Ye poori `flutter-poc/` folder apne GitHub repo mein push karo
2. Repo Settings -> Secrets and variables -> Actions mein ye 2 secrets add karo (SonarQube use karna hai to):
   - `SONAR_TOKEN`
   - `SONAR_HOST_URL`
3. `main` ya `develop` branch pe push karte hi pipeline automatically chalega

## Pipeline Flow

```
Code Push
   |
   v
[Job 1] Flutter build + flutter analyze + flutter test --coverage + APK build
   |
   v
[Job 2] SonarQube scan -> Quality Gate check (fail hua to pipeline yahin rukega)
   |
   v
[Job 3] Karate functional/API tests
   |
   v
[Job 4] Deploy (abhi commented out / disabled - POC ke liye zarurat nahi)
```

## Notes

- Karate tests `reqres.in` (free public mock API) use kar rahe hain POC ke liye. Apne real backend API se `login.feature` ka URL replace kar dena.
- SonarQube job skip ho sakta hai agar abhi SonarQube server setup nahi hai — bas us job ko workflow file se hata dena ya `if: false` laga dena.
- Deploy job jaan-bujh kar comment out hai — Play Store account ke bina bhi pura CI pipeline test ho sakta hai.
