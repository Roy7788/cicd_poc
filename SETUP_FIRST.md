# Pehle Ye Karo — Setup Steps

Is zip mein sirf **app code, tests, aur CI/CD config** hai. `android/` aur `ios/` folders
(jo APK build karne ke liye zaroori hain) isme nahi hain, kyunki wo Flutter SDK khud
generate karta hai — aur wo sirf tumhare PC par hi ho sakta hai.

## Step 1 — Zip extract karo apni pasand ki jagah, e.g.:
```
C:\Users\Hello\cicd_poc_new
```

## Step 2 — Us folder ke andar jaake Flutter se android/ios generate karwao

```powershell
cd C:\Users\Hello\cicd_poc_new
flutter create .
```

⚠️ Dhyan rakhna: `flutter create .` chalate waqt Flutter tumhari `lib/main.dart`,
`test/widget_test.dart`, `pubspec.yaml` ko **overwrite nahi karega** agar wo already
maujood hain aur project name match karta hai — bas missing `android/`, `ios/`,
`web/` folders create kar dega.

## Step 3 — Dependencies install karo
```powershell
flutter pub get
```

## Step 4 — Git init yahi folder ke andar karo
```powershell
git init
git rev-parse --show-toplevel
```
Output exact `cicd_poc_new` folder ka path hona chahiye — agar kuch aur dikhe to
ruk jao aur pehle wahi fix karo.

## Step 5 — Check karo kya track ho raha hai (commit se pehle)
```powershell
git status
```
Sirf project files dikhni chahiye. `.gitignore` already isi zip mein diya hua hai,
isliye build/SDK/keystore files automatically ignore ho jaani chahiye.

## Step 6 — Commit aur push
```powershell
git add .
git commit -m "Initial CI/CD POC setup"
git branch -M main
git remote add origin https://github.com/<username>/cicd_poc.git
git push -u origin main
```

## Step 7 — Karate tests ke liye Maven chahiye
```powershell
mvn -version
```
Agar command na chale, Maven install karo: https://maven.apache.org/download.cgi

---

Ye sab hone ke baad GitHub push karte hi Actions tab mein pipeline automatically
chalegi (Flutter tests → SonarQube → Karate tests → APK artifact).
