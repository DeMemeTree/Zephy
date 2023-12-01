# Zephy

## Description
Zephy is an iOS application designed to be a private secure wallet for Zeph/ZSD/ZRS ecosystem. This application aims to be an opensource project that I take and host on the appstore with my LLC. Anyone can contribute and I dont intend to put any ADs or put it in the app store for any money. In other words I want it to be free. I want it to be dank. 🧙‍♂️

## Features
- Transfer/Receive Zeph/ZSD/ZRS
- Be up to date on the network statistics and metrics
- Secure, Private, Non-Custodial Zephyr Wallet

## App UI
Here you can see some of the main screens of the app:

![Demo](https://github.com/DeMemeTree/Zephy/demo/demo.gif)

## To-Do
- [ ] Modify the helper lib to handle Zephyr/ZSD/ZRS 
- [ ] Improve Scripts/Automation of build pipeline
- [ ] Create Testflight and run an MVP of the app with a group of people
- [ ] App store submission

## Donations
If you find Zephy helpful and would like to support its development, consider making a donation. Your contribution helps in maintaining and improving the app.

**Crypto Donations:**
- **Zephyr (Zeph):** `ZEPHsAZcr7shFkDRyF9NGp8q8wqUA3k2qR49ir5C11GKGzvSEMU9mCabpg4zAU4XrcczurQ9SeGxoZ6LQGhL8rbtfJmRirReeW5`
- **Zephyr Stable Dollar (ZSD):** `ZEPHsAZcr7shFkDRyF9NGp8q8wqUA3k2qR49ir5C11GKGzvSEMU9mCabpg4zAU4XrcczurQ9SeGxoZ6LQGhL8rbtfJmRirReeW5`
- **Zephyr Reserve Shares (ZRS):** `ZEPHsAZcr7shFkDRyF9NGp8q8wqUA3k2qR49ir5C11GKGzvSEMU9mCabpg4zAU4XrcczurQ9SeGxoZ6LQGhL8rbtfJmRirReeW5`

## Getting Started
Currently things are a little bit more manual than I would like

The Two commands Im currently running
```bash
./build_zephyr_all.sh
```

```bash
./setup.sh
```

Once both of those commands are run then I run the following

Building the ZephySDK Framework
```bash
xcodebuild -project ZephySDK.xcodeproj -scheme ZephySDK -configuration Release -sdk iphoneos
```
You can find the framework in the derived data folder, which you can copy into the Zephy project.

The library is not created in a way that it works in the simulator. You could in theory tweak things to setup it as such but I am just testing on my phone.

## Contributing
Just raise a PR if I find it to be useful or dank then I will merge it in.

## License
MIT
