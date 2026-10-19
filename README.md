# TugCheck

TugCheck times the Timed Up & Go walk so you can track your mobility and share the results with your doctor. A helper holds the iPhone and runs the timer. The person being tested does not hold the phone.

TugCheck is a wellness tool. It does not diagnose or treat any condition. Twelve seconds is only a reference point. The trend over time matters most.

Results stay on the iPhone. There is no account.

## Run it on your iPhone

You need:

- A Mac
- An iPhone with iOS 17 or later
- A cable to connect the iPhone to the Mac (the one that came with the phone, or a newer USB-C cable)
- A free Apple ID (the same one you use for the App Store is fine)
- Xcode, which is free from the Mac App Store

You do not need a paid Apple Developer account.

### 1. Install Xcode

1. On the Mac, open the **App Store**.
2. Search for **Xcode**.
3. Click **Get** or **Install**, then wait for it to finish. This is a large download.
4. Open **Xcode** once. If it asks to install extra components, click **Install** and wait.

Xcode 15 or newer is required.

### 2. Download TugCheck

1. On this GitHub page, click the green **Code** button.
2. Click **Download ZIP**.
3. Find the zip file in **Downloads** and double-click it. A folder named something like `tugcheck-main` appears.
4. Move that folder somewhere easy to find, such as your Desktop.

### 3. Open the project

1. Open the unzipped folder.
2. Double-click the blue **TugCheck** icon named `TugCheck.xcodeproj`.
3. Xcode opens. The first time, it may take a minute to get ready.

Open the blue project icon, not a loose folder of files.

### 4. Turn on Developer Mode on the iPhone

Apple hides this until a computer tries to install an app, so do this step after Xcode is open.

1. Plug the iPhone into the Mac.
2. Unlock the iPhone. If it asks you to **Trust This Computer**, tap **Trust** and enter the iPhone passcode.
3. On the iPhone, open **Settings**.
4. Tap **Privacy & Security**.
5. Scroll to the bottom and tap **Developer Mode**.
6. Turn **Developer Mode** on.
7. Tap **Restart** when the iPhone asks. After it turns back on, unlock it and tap **Turn On** to confirm.

If you do not see **Developer Mode**, continue with the next step and come back here after you press Run in Xcode. The menu often appears only after that first attempt. Then restart the iPhone and try Run again.

### 5. Sign in with your Apple ID

1. In Xcode, click the blue **TugCheck** icon at the top of the left sidebar.
2. Under **TARGETS**, click **TugCheck** (not TugCheckTests).
3. Open the **Signing & Capabilities** tab.
4. Check **Automatically manage signing**.
5. Next to **Team**, open the menu.
6. Choose **Add an Account…** if your Apple ID is not listed.
7. Sign in with your Apple ID.
8. Go back to the Team menu and choose the team named **Your Name (Personal Team)**.

If Xcode says the bundle identifier cannot be registered, change **Bundle Identifier** to something unique, such as `com.yourname.tugcheck`. Use letters and dots only, with your own name in the middle.

### 6. Choose your iPhone and press Run

1. At the top of the Xcode window, click the device menu (it may say a simulator name, such as iPhone 16).
2. Under **iOS Device**, choose your iPhone. Do not choose a simulator if you want it on your phone.
3. Click the **Run** button (the triangle) or press Command-R.
4. Wait while Xcode builds the app. The first build can take several minutes.
5. The app installs and opens on the iPhone.

### 7. Trust yourself as the developer

The first launch often fails until the iPhone trusts your Apple ID.

1. On the iPhone, open **Settings**.
2. Tap **General**.
3. Tap **VPN & Device Management**. On some iPhones the row is named **Device Management**.
4. Tap the row with your Apple ID email.
5. Tap **Trust**, then tap **Trust** again.
6. Open **TugCheck** from the home screen, or press Run in Xcode again.

### 8. When the app stops opening after 7 days

A free Apple ID can only keep a personally installed app working for **7 days**. After that, the icon may still be there, but tapping it will not open the app.

To refresh it:

1. Plug the iPhone into the Mac.
2. Open `TugCheck.xcodeproj` in Xcode.
3. Choose your iPhone in the device menu.
4. Press the **Run** button again.

Your saved people and results stay on the iPhone. You are reinstalling the app, not creating an account.

## How to use TugCheck

A helper holds the phone the whole time.

1. On the home screen, tap **Start a TugCheck**.
2. Choose the person. The first person is named **Me**. You can rename them under **People**.
3. Set **Walking aid used** if they will use a cane, walker, or other aid. Next time, this starts from the previous choice.
4. Tick every safety item. Use the same chair each time.
5. Read the instructions aloud.
6. Before the first timed walk, do the practice walk. It is not timed.
7. The phone counts 3, 2, 1, then says **Go**. The timer starts on **Go**.
8. Tap **Stop** when the person is fully seated.
9. Add an optional note or observations, then tap **Save**, **Retake**, or **Discard**.
10. Open a person to see their history, the chart, and **Share**.

Stop the test if the person feels dizzy, has pain, or is short of breath. Keep someone nearby.

## For someone helping with the computer

The Xcode project is `TugCheck.xcodeproj`. It targets iOS 17, iPhone, Swift 5, SwiftUI, SwiftData, and Swift Charts. There are no third-party packages.

- `TugCheck/Models` stores people and results.
- `TugCheck/Views` is the screens.
- `TugCheck/Services` is the timer, the spoken “Go”, and the share text.
- `TugCheckTests` checks the timer and the result text.

GitHub Actions builds the app and runs the tests on a Mac runner when changes are pushed or a pull request is opened. That check is in `.github/workflows/ios.yml`.
