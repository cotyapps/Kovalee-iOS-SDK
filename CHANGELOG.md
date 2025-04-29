# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


<<<<<<< HEAD
=======
## [2.0.7] - 2025-04-29
### :bug: Bug Fixes
- [`a6c9656`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/a6c9656ccd61a192e8020325ed09b8d7114cd79f) - sending always first_app_open event *(commit by [@fto-k](https://github.com/fto-k))*
- [`90334c9`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/90334c9f144ba100e730eb1aa707557ab02c219b) - unified sdk state and cv manager state *(commit by [@fto-k](https://github.com/fto-k))*
- [`777ce60`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/777ce60ba6b973865f6bae2a8a58e8d2d49e02d0) - removed re-settin isFirstAppOpen flag *(commit by [@fto-k](https://github.com/fto-k))*
- [`08f60db`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/08f60db77b0734da3adba8168905a625f6ed649b) - better handling of SDK State *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`565af6c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/565af6ccd3c7cac38e1e48992c319216b202b221) - added more debugging to understand current issue *(commit by [@fto-k](https://github.com/fto-k))*
- [`8736e53`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/8736e538fe007dd917c4989fe6e4ae337021bfd1) - moved first_app_open event before fetching starts *(commit by [@fto-k](https://github.com/fto-k))*
- [`e718af5`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/e718af5ace857e95d1097e0cb024de1ab039cf7c) - rolled back code to previous working state *(commit by [@fto-k](https://github.com/fto-k))*


## [2.0.6] - 2025-04-24
### :sparkles: New Features
- [`fc58a6d`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/fc58a6d628368d44d993667311e38a97f9f9c414) - sending coarseValue with update_conversion_value event *(commit by [@fto-k](https://github.com/fto-k))*


## [2.0.4] - 2025-04-24
### :sparkles: New Features
- [`4f336c6`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/4f336c6af3e17a737ac7ce9edb6e1c06cce77b97) - migrated internal state storage to actors *(commit by [@fto-k](https://github.com/fto-k))*


## [2.0.3] - 2025-04-15
### :sparkles: New Features
- [`cf20f3e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/cf20f3e3bc1ec6f91ccdb161259a06a337c3e02f) - improved SDK State Management *(commit by [@fto-k](https://github.com/fto-k))*

### :bug: Bug Fixes
- [`942855f`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/942855ff8e008e31f5eb4c5abe662bf71c7c77ba) - small fix for SDK storage *(commit by [@fto-k](https://github.com/fto-k))*
- [`81ad8c8`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/81ad8c81121be993c8ecc2cc57a0c71ace24cf87) - loop if no events sequence is found *(commit by [@fto-k](https://github.com/fto-k))*


## [2.0.1] - 2025-04-15
### :sparkles: New Features
- [`fe1a1a2`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/fe1a1a2186fe3175081704d85009b1586812924d) - exposing AttributionDelegate *(commit by [@fto-k](https://github.com/fto-k))*
- [`5c1cb94`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/5c1cb940927ab2f3119b627b5f2f706941c380c4) - add new user property if user comes from TestFlight *(commit by [@fto-k](https://github.com/fto-k))*

### :bug: Bug Fixes
- [`501b6b3`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/501b6b3183da924f87d25b2c88cfd3ef12dfe332) - restore Attribution Callback *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`97c455f`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/97c455f3e05444ffa58952af5c65b2921ca9a997) - changed RC package to https://github.com/RevenueCat/purchases-ios-spm *(commit by [@fto-k](https://github.com/fto-k))*


## [2.0.0] - 2025-04-01
### :sparkles: New Features
- [`6a26ea5`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/6a26ea55cbd4e73cebe143d5cbc70f68c407030a) - Merge libraries *(commit by [@Moez6060](https://github.com/Moez6060))*
- [`6fd789d`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/6fd789d3d362c549998931bf9938aecfeb31ed04) - Pods *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`6d78d4c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/6d78d4c844560756a3614a75e61262b0152c2997) - FetchEvents *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`5a2cfd6`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/5a2cfd60a6496afe87e101a7dadee42e891d2c4f) - Framework update *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`7e56a75`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/7e56a753f71ede00a439504ccb5e26fb8733d651) - Debug console update *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`f8e3c9a`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f8e3c9a6cb3e9a0893e96d07cd0935a209f9c256) - add sequenceVersion and parsingLogic to SDK console *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`53b73e9`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/53b73e9ad8f2af75626987afbbb7104c5a1451ce) - Refresh sequences *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`dfed623`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/dfed62374c2b27e40070d96a6104719cb5f3c892) - W2W *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`ea98fa9`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/ea98fa9e52fc5a13bc0dafc5541f3e3a19e6b389) - Framwork update *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`3369374`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/33693746181339b5b59ec74bab49b612852cbf3a) - Reset App *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`630b527`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/630b527cd50a1c9e9d2d7361371c5e078b958c24) - Haptic feedback *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`1d39655`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/1d39655187c7563749340498f5e3e7454fba8128) - updated parsing logic *(commit by [@fto-k](https://github.com/fto-k))*
- [`4d83d60`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/4d83d60953ce118e6c56432447788da344ff9c0b) - bumped Fireabse minimum version to 11, removed unused dependencies *(commit by [@fto-k](https://github.com/fto-k))*
- [`e99c3ec`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/e99c3ec0e2fa106679abe2a4f8aa52fa1a19f7ca) - refactoring code to structured concurrency *(commit by [@fto-k](https://github.com/fto-k))*
- [`6fbc389`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/6fbc389f230a7921d689e54110be3df8b1ae4bd2) - migration to Swift 6 *(commit by [@fto-k](https://github.com/fto-k))*

### :bug: Bug Fixes
- [`ea00391`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/ea003917342041233fc6f8fb893c8b9a95e08a83) - Remove KovaleePaywall *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`29f9102`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/29f9102c8984af43f311dbfed2763b9def8ae3da) - License *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`46f67bd`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/46f67bd2f6d0cda23746947a6a323b3af0b6157c) - Remove Superwall *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`f89c5d1`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f89c5d1f71f86843b3c4bdc1cc4f9d8718bccb60) - podspec homepages *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`f8cad36`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f8cad36ba053af888e41856e7f582961cc8ace92) - remove comment *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`4bb6acc`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/4bb6accaabaaf382ce0ba0f1f4bb3c2187e83502) - updated gitignore *(commit by [@fto-k](https://github.com/fto-k))*
- [`55478f9`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/55478f9a051a5fbdf0c34724288d8bc3a2428bbd) - Add setupConversionManager *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`426a4fb`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/426a4fb5844c1da5acea62091f10a4b17871c8c0) - Crash fix *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`3af9232`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/3af9232ee15b3522a040c4733ca56fb4354fb4a0) - merge conflict *(commit by [@fto-k](https://github.com/fto-k))*
- [`90bcce0`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/90bcce030a77d4cfecf00f456a68d361075a83ae) - sequence file load logic *(commit by [@fto-k](https://github.com/fto-k))*
- [`b60c707`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/b60c707ccc4f2608f0bf4288b23f985ec1de4ae7) - fixed issue in cvmanager *(commit by [@fto-k](https://github.com/fto-k))*
- [`f6cfe98`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f6cfe98be94152a11aadc7037ca615a35eb2668e) - updated hardcoded file naming convention *(commit by [@fto-k](https://github.com/fto-k))*
- [`013baee`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/013baee9c8c9b00ab46638c68ff1308732e91ed9) - first_app_open redundant code *(commit by [@fto-k](https://github.com/fto-k))*
- [`9c4aa73`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/9c4aa73164bb9dbd259f0ca8bc644411acb3812b) - rolled back hardcoded file name *(commit by [@fto-k](https://github.com/fto-k))*
- [`95f9aa5`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/95f9aa58c4e99d690faf9d693fd97d5197198465) - add sdk dependency *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`a26f719`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/a26f7193bad7d60b0defa9430b42d2eb7c1eb053) - removed unnecessary Firebase params from KovaleeKeys *(commit by [@fto-k](https://github.com/fto-k))*
- [`df1f01c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/df1f01c2897e6d3e9ce7af6031dd94b5240b6a16) - updated events sequences folder structure + added a few utility functions + updated Debug console *(commit by [@fto-k](https://github.com/fto-k))*
- [`77a0982`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/77a09826b9a9c2f03b6fa2005120c7f87cfcefd4) - possible fix for CV issue *(commit by [@fto-k](https://github.com/fto-k))*
- [`c6e434b`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/c6e434b27b04c09575b81b9b3ec373089cf9267b) - debug console *(commit by [@fto-k](https://github.com/fto-k))*
- [`99edf8b`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/99edf8b66826f22ca075e8a2ef4f47a46ea0c71a) - small UI update in debugger *(commit by [@fto-k](https://github.com/fto-k))*
- [`7fecef5`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/7fecef5c36b09d642b7b7afdbd2d99c1431aa3d7) - cleanup function *(commit by [@fto-k](https://github.com/fto-k))*
- [`b7b8068`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/b7b8068ca5ae0d1231fbd4e419958e6f84e9b407) - refreshing session count *(commit by [@fto-k](https://github.com/fto-k))*
- [`1e618c6`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/1e618c6564adfc2567b78ecd15d61b26518a5e6b) - posible fix for CoarseValue *(commit by [@fto-k](https://github.com/fto-k))*
- [`778c053`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/778c053fdbd4c55e37550bf13fb99e162f671dad) - coarse value parsing *(commit by [@fto-k](https://github.com/fto-k))*
- [`84e3f53`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/84e3f53e03e0187fb5b359aa220de956ab38cdc4) - cleanup CV on appreset *(commit by [@fto-k](https://github.com/fto-k))*
- [`a973f9d`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/a973f9d2a556f8e5d097de952bf9ba783e61c858) - updated parsing logic for payment events *(commit by [@fto-k](https://github.com/fto-k))*
- [`2ad2928`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/2ad29289d51fe6384d659b23e7ec77be86362a0b) - renamed Kovalee purchases data model to avoid any conflict with StoreKit *(commit by [@fto-k](https://github.com/fto-k))*
- [`bc29103`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/bc29103f8faa7993dc3d8e340244ea1510eccff4) - sdk won't send coarse value in case it's not set *(commit by [@fto-k](https://github.com/fto-k))*
- [`147b671`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/147b671dd26dd83ce467a3f9d1ea0059a193d068) - enabled adid caching *(commit by [@fto-k](https://github.com/fto-k))*
- [`78a90fa`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/78a90fa5de67aa6dc5d8811a392cc93ff0436428) - updated force unwrappign *(commit by [@fto-k](https://github.com/fto-k))*
- [`baf01c8`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/baf01c806b331e73c3d1c168bd65d0e004694f09) - removed detached task *(commit by [@fto-k](https://github.com/fto-k))*
- [`ed16dac`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/ed16dac91ad0b894b26749ecade34355f08a2e43) - moving current Storage code to Actor *(commit by [@fto-k](https://github.com/fto-k))*
- [`3621e5a`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/3621e5ad8fd7fccd00a316a047ac48338685bf2e) - restored Google Analytics dependency *(commit by [@fto-k](https://github.com/fto-k))*
- [`64c1e2f`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/64c1e2f2b0052a0787a5699a717b8dd644c22d64) - possible fix of late app_open event *(commit by [@fto-k](https://github.com/fto-k))*
- [`4887a8c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/4887a8c83f5b3a31f3ea72b7fe0f0eda0944fcbc) - split sdk library in different targets *(commit by [@fto-k](https://github.com/fto-k))*
- [`92b2d2e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/92b2d2ea353fe373f5978ac059ae8e4eb6584683) - structure concurrency in remote config target *(commit by [@fto-k](https://github.com/fto-k))*
- [`a8bc1c6`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/a8bc1c6a7a348c66823e2143e286e65068243eea) - async functions after moving to structured concurrency *(commit by [@fto-k](https://github.com/fto-k))*
- [`6ce03d4`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/6ce03d458373c1d299ebc175afd24fcd91573889) - fixed KovaleeUI *(commit by [@fto-k](https://github.com/fto-k))*
- [`3eb9f41`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/3eb9f41e5a8f22f8d690eba1700860f117e03053) - Storage thread safety *(commit by [@fto-k](https://github.com/fto-k))*
- [`589e818`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/589e818e6fcd5d0d466411514c8ac85f6af675ee) - Storage thread safety - rollback *(commit by [@fto-k](https://github.com/fto-k))*
- [`f542b74`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f542b745b99e89c714fba507fdf42b016c02d3ab) - Storage thread safety - rollback *(commit by [@fto-k](https://github.com/fto-k))*
- [`0c547db`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/0c547dbd28c453e636a3b2a1c35708ee93238df4) - Storage thread safety - rollback *(commit by [@fto-k](https://github.com/fto-k))*
- [`227379b`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/227379b8052e41b0ef02a7a69c95be44dcd6dbb6) - Storage thread safety - complete rollback *(commit by [@fto-k](https://github.com/fto-k))*
- [`9716d71`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/9716d71747f4cfd68f880570edfcfb368f096f54) - Storage thread safety - complete rollback *(commit by [@fto-k](https://github.com/fto-k))*
- [`5552def`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/5552defc83b7ba444d3c81e4d9bb2a30cf4b1623) - Storage thread safety - rollback *(commit by [@fto-k](https://github.com/fto-k))*
- [`3694914`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/3694914388c04d7c7fdca61b65d0e534708fc8a3) - Storage thread safety - rollback *(commit by [@fto-k](https://github.com/fto-k))*
- [`aed776e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/aed776ee6ea347db2b36c3b6d026005dd6db5eeb) - Storage thread safety - Actor *(commit by [@fto-k](https://github.com/fto-k))*
- [`9bf181d`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/9bf181d2ab8e63b53636437e6a78e7089b4591bd) - removed force unwrapping in purchase functions *(commit by [@fto-k](https://github.com/fto-k))*
- [`05aedcc`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/05aedcc50e290bb3f78d186fdbeef02774b03e80) - postponing RC userId setting in case it's not yet initialized *(commit by [@fto-k](https://github.com/fto-k))*
- [`5ce5c88`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/5ce5c88adf17988296bfc81de71fa760759f2025) - refactored Storage *(commit by [@fto-k](https://github.com/fto-k))*
- [`ddd39e2`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/ddd39e2d6ea82e02eeca8f2d945f06d07a3a84c6) - setting default values in Storage *(commit by [@fto-k](https://github.com/fto-k))*
- [`9e58788`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/9e587885a55d4cb176e30b18b75b79eade241076) - enabling events sending *(commit by [@fto-k](https://github.com/fto-k))*
- [`1c047e5`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/1c047e5cd7624a7701778dacf4579cc97fcec8c4) - setting first_app_open *(commit by [@fto-k](https://github.com/fto-k))*
- [`aaf6c0c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/aaf6c0ce7b0a56307edbb9de3cf1b1894f666e96) - possible fix for sending multiple cv *(commit by [@fto-k](https://github.com/fto-k))*
- [`62cd519`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/62cd519ae2c586aafb0f0bbe83ed8b85e025599d) - make EventsCache thread safe *(commit by [@fto-k](https://github.com/fto-k))*
- [`7b68296`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/7b68296c9d12552347bf3fca683ea17e561e6fa1) - enabling events sending *(commit by [@fto-k](https://github.com/fto-k))*
- [`1267db3`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/1267db3e5ce0ecbda8a0b0b2f04eadf01e30e64c) - merge conflict *(commit by [@fto-k](https://github.com/fto-k))*

### :recycle: Refactors
- [`f6c487f`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f6c487ff5b31c0e4db8749a0e2413f33c1fb5801) - KovaleeManager code cleanup *(commit by [@fto-k](https://github.com/fto-k))*
- [`775616c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/775616cda716ef47f6234662eeee47eb64e2b48e) - removed KovaleeManager setup which is now handled by the manager itself *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`179dcee`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/179dceebe88befbcaadb7176de01cea20854272a) - Update SDK Version *(commit by [@ElMoez](https://github.com/ElMoez))*
- [`04a9bd6`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/04a9bd606d848aa410b1e4fcd61605f8daf2133f) - migrated to Swift 6 and structured concurrency *(commit by [@fto-k](https://github.com/fto-k))*
- [`920435e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/920435ef9598fb22dc7e992a93e3e16f1c8c2eb0) - bumped package *(commit by [@fto-k](https://github.com/fto-k))*
- [`5745a3a`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/5745a3a11085252fc21ed00003179e6948822c69) - new xcframework build *(commit by [@fto-k](https://github.com/fto-k))*


## [1.12.5] - 2024-12-12
### :bug: Bug Fixes
- [`4e15d37`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/4e15d37ebb42fd0ba0ea1b35fa2030044e6a1176) - OnboardingData properties are now public *(commit by [@fto-k](https://github.com/fto-k))*


## [1.12.4] - 2024-12-11
### :sparkles: New Features
- [`d7de897`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/d7de897c09f87256c55eb1281373a5ba553f30ba) - new function to retrieve web onboarding data *(commit by [@fto-k](https://github.com/fto-k))*

### :bug: Bug Fixes
- [`8a326f0`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/8a326f03315edcc2fffc0c600d3375a3c1365e0e) - fixed KovaleeUI version *(commit by [@fto-k](https://github.com/fto-k))*


## [1.12.3] - 2024-10-18
### :bug: Bug Fixes
- [`ccc03fa`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/ccc03fa5cdee79772ff94429383f0a06b59b9847) - setting user as premium when puchased lifetime offer *(commit by [@fto-k](https://github.com/fto-k))*
- [`b726fcd`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/b726fcdaa6c619f2d68123066b2244a1d82a0fa7) - lifetime purchase update *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`92c5b8f`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/92c5b8f643898e4f198e0effbc3f6a2e37f81d7a) - commented out pod in fastlane *(commit by [@fto-k](https://github.com/fto-k))*


## [1.12.1] - 2024-10-18
### :bug: Bug Fixes
- [`fad59af`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/fad59aff876da808f538a12011e4b4d9cca36359) - lifetime users are not set as premium *(commit by [@fto-k](https://github.com/fto-k))*
- [`170b09e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/170b09e01b9d15d589efeae899b09c1a46c0a59a) - updated purchase data model *(commit by [@fto-k](https://github.com/fto-k))*
- [`1211c37`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/1211c3764f677f866949888cf9875e5ee47f8b69) - updated purchase data model *(commit by [@fto-k](https://github.com/fto-k))*
- [`99c61ab`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/99c61ab0b20f1f0bc1851442f296a23271d4cc35) - updated purchase data model *(commit by [@fto-k](https://github.com/fto-k))*
- [`a7a3e39`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/a7a3e39f92c3c9fc234c262f87d425acb76f29cc) - updated purchase data model abstraction *(commit by [@fto-k](https://github.com/fto-k))*
- [`0343304`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/03433043a7222d2ea4b4190216a29ad087fbb302) - refactored purchase DataModel *(commit by [@fto-k](https://github.com/fto-k))*
- [`2ede5ba`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/2ede5ba393c6eeeb1199a65f601370f3bcf7082f) - update logic to set user as premium *(commit by [@fto-k](https://github.com/fto-k))*


## [1.12.0] - 2024-10-17
### :sparkles: New Features
- [`80e380b`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/80e380be9db0fd36bec278b8a8ba6a6ea2229bc4) - added new function to set a dictionary of user properties *(commit by [@fto-k](https://github.com/fto-k))*
- [`1c2e429`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/1c2e429764cf5455af559106f845cfb1002ef8be) - updated Attribution functions to comply with Adjust v5 *(commit by [@fto-k](https://github.com/fto-k))*

### :bug: Bug Fixes
- [`a297ee3`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/a297ee3b1946739fa64284d46765368376c312a1) - fixed DebugView adid retrieval *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`4017193`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/40171937e5d059bed547d4b8093c5eda5ff1982a) - cleaned up functions declaration *(commit by [@fto-k](https://github.com/fto-k))*


## [1.11.0] - 2024-10-07
### :sparkles: New Features
- [`ac939ec`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/ac939ecb7a03f830f2559bdb2421bf925b34c65f) - new experimental feature flag *(commit by [@fto-k](https://github.com/fto-k))*


## [1.10.9] - 2024-09-26
### :sparkles: New Features
- [`045d82c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/045d82cd81ace6f4145ec4ef1b30635274756d06) - added email domain user property if user is part of a bundle *(commit by [@fto-k](https://github.com/fto-k))*


## [1.10.8] - 2024-09-17
### :bug: Bug Fixes
- [`77aac45`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/77aac4552840078b18880e6fad23cbc7f27dc997) - updated bundle input parameter *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`cd46784`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/cd467841e6ec0178af4da25c7eec29e53f395231) - bumped podspec version *(commit by [@fto-k](https://github.com/fto-k))*


## [1.10.7] - 2024-09-13
### :sparkles: New Features
- [`76b757c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/76b757c3f4cc4190197bda36fcff2d34999eab54) - updated bundle-check function with new backend endpoint *(commit by [@fto-k](https://github.com/fto-k))*

### :bug: Bug Fixes
- [`dc25cc9`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/dc25cc9335369644642b8e964ed9a17c32034ec2) - solved PrivacyInfo declaration issue *(commit by [@fto-k](https://github.com/fto-k))*


## [1.10.5] - 2024-08-21
### :bug: Bug Fixes
- [`d267cb8`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/d267cb8b4fde659f5bb98b67d1c95a9d0b13f374) - sdk now converts purchase events properties to durations for mature apps *(commit by [@fto-k](https://github.com/fto-k))*


## [1.10.4] - 2024-08-01
### :bug: Bug Fixes
- [`9a1f564`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/9a1f56491c298179500c430a99e114e342a3eae9) - fixed possible issue on capabilities setup *(commit by [@fto-k](https://github.com/fto-k))*


## [1.10.3] - 2024-08-01
### :bug: Bug Fixes
- [`10272ba`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/10272ba1689677e6f47ec9644be63045cbf8cf60) - updated KovaleeSurveyManagerImpl implementation to avoid running for mac catalyst *(commit by [@fto-k](https://github.com/fto-k))*
- [`2fe1ce7`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/2fe1ce780a482aeae156935c83bead557895bc40) - only initialize Survicate if key is present in KovaleeKeys *(commit by [@fto-k](https://github.com/fto-k))*
- [`f939733`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f9397331ac6773ab3f5827b59aca93cb6adb7068) - sending app_code as user property to filter Survicate user audience *(commit by [@fto-k](https://github.com/fto-k))*
- [`cbb676c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/cbb676c13018e0efdb53a27b928489fe1b82242c) - moved set app_code for every user not only new ones *(commit by [@fto-k](https://github.com/fto-k))*


## [1.10.1] - 2024-07-15
### :bug: Bug Fixes
- [`a23e11f`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/a23e11fe3d69d3b8978ec78f796186b1f17db990) - Added condition based on platform to use Survicate as dependency *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`605ce30`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/605ce3013f176faf8a4d67624b076d89f46287a8) - adde pod specific lanes to fastlane *(commit by [@fto-k](https://github.com/fto-k))*
- [`a62bef9`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/a62bef951e435c51f839b7aabcfac3076fd51671) - updated .gitignore *(commit by [@fto-k](https://github.com/fto-k))*


## [1.10.0] - 2024-07-03
### :sparkles: New Features
- [`dd91be7`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/dd91be7cdaea1280d92ecf942af630143f33a6bb) - implement Survicate methods on KovaleeSurveyManager *(commit by [@rodrigowoulddo](https://github.com/rodrigowoulddo))*
- [`1bf2c6c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/1bf2c6c20ef25e3d69cfee57088e4759f4a4ed15) - implement methods on KovaleeSurveyManagerImpl *(commit by [@rodrigowoulddo](https://github.com/rodrigowoulddo))*
- [`f0c1100`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f0c110017bd1fe921ea8b0a8d6cbb5a7578c3714) - expose setSurveyDelegate *(commit by [@rodrigowoulddo](https://github.com/rodrigowoulddo))*
- [`ad4fd0f`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/ad4fd0fe504f63645a893cb02d41f8a4651a7f73) - update KovaleeFramework *(commit by [@rodrigowoulddo](https://github.com/rodrigowoulddo))*

### :bug: Bug Fixes
- [`8c697b1`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/8c697b134bb91a8c873beceaac2161f3fb4ec9d3) - make setSurveyDelegate public *(commit by [@rodrigowoulddo](https://github.com/rodrigowoulddo))*
- [`97e05b5`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/97e05b5314532aa59296148ccbb073e532ac3fe1) - export KovaleeSurvey target *(commit by [@rodrigowoulddo](https://github.com/rodrigowoulddo))*
- [`d89ec4a`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/d89ec4ac59f9808a3644f20287ee8b6262f423c1) - trying to fix remote Survey activation *(commit by [@fto-k](https://github.com/fto-k))*
- [`a5da0a0`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/a5da0a0f6f93e70c5f67d4984ab6d6507a92a53a) - trying to fix remote Survey activation *(commit by [@fto-k](https://github.com/fto-k))*
- [`04f890b`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/04f890baf0efb247d8066a328d03dc1cecec4fda) - added new way to deactivate SurveyKit *(commit by [@fto-k](https://github.com/fto-k))*
- [`db3bd68`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/db3bd68b635e6474adfc39c4af57e0fae88e1530) - resetting SurveyKit *(commit by [@fto-k](https://github.com/fto-k))*
- [`b8a5169`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/b8a516963e4d7c0bbb93138bfd37d475143dc276) - moved survey check on initialization *(commit by [@fto-k](https://github.com/fto-k))*
- [`0977fe0`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/0977fe05504479b16df7f08cd685e04193a93c3b) - moved survey check on initialization *(commit by [@fto-k](https://github.com/fto-k))*
- [`957b8be`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/957b8be83c2c6a5bc9a7874a4811a48f049edd5b) - set amplitude id on the first survey display if it doesn't exist *(commit by [@rodrigowoulddo](https://github.com/rodrigowoulddo))*
- [`7f9f222`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/7f9f222b424c858ecd698f74ad12ca4a49575a21) - remove unused deactivate() function from KovaleeSurveyManagerImpl *(commit by [@rodrigowoulddo](https://github.com/rodrigowoulddo))*

### :wrench: Chores
- [`3a4696b`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/3a4696bb43071859d14f0462d0d060231e34be90) - fixed issue in fastfile *(commit by [@fto-k](https://github.com/fto-k))*
- [`80f434d`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/80f434d95245d0c1b29f37a340fe1c80f3d95236) - added new target KovaleeSurvey *(commit by [@fto-k](https://github.com/fto-k))*
- [`def0dc5`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/def0dc56a245fbc967f65ae36189884d1f9cf31d) - created KovaleeSurvey target *(commit by [@fto-k](https://github.com/fto-k))*
- [`e7f00b7`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/e7f00b7d854d2e6129d89d1ccfbc1baa5579137d) - updated fastlene to handle new KovaleeSurvey podfile *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.22] - 2024-06-27
### :sparkles: New Features
- [`c7866c1`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/c7866c1ae87f2166c68631d32e4588ef2b162d22) - exposing RC set email function *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.21] - 2024-06-06
### :sparkles: New Features
- [`e4622b1`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/e4622b12d589759af91d49dcb5dd5090b2daebca) - implemented alreadIntegrated flag for apps that already have kovalee tools integrated *(commit by [@fto-k](https://github.com/fto-k))*

### :bug: Bug Fixes
- [`cfea482`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/cfea4820f6e3eb1a0135baa6be976e8b58c7b7d3) - fixed fastlane script *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`65deaa0`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/65deaa0c6fdb4b0dd4461cd244b005cebbb61c45) - fastlane file update *(commit by [@fto-k](https://github.com/fto-k))*
- [`f48d7e7`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f48d7e7d732fdc436fe8a2f84cec7cb7a0d083f5) - fastlane file update *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.20] - 2024-06-04
### :sparkles: New Features
- [`551601e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/551601e68435bd02734e55055bbb880a01022fb6) - setting Amplitude Id also for deprecated purchase function *(commit by [@fto-k](https://github.com/fto-k))*
- [`1f14868`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/1f148683a610faed037425aca7235103a703c623) - setting user as premium after login if needed *(commit by [@fto-k](https://github.com/fto-k))*
- [`c0ad779`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/c0ad779e0be40e54a33daf683208a5e99ec54ec3) - checking for premium on RC login *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`52d23f7`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/52d23f7dbafa17087ad9e6ab3dfe29b3b4dfcafa) - cleaned up fastfile *(commit by [@fto-k](https://github.com/fto-k))*
- [`1e72439`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/1e7243975affc647949a9882d0d42a3c314a6b1a) - added error logs in case no hardcoded CV has been found *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.19] - 2024-06-04
### :sparkles: New Features
- [`a2b9961`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/a2b996129482fc0004a9d26f62a381771f0fa673) - setting AmplitudeId just before purchase if no amplitude Id has been set before *(commit by [@fto-k](https://github.com/fto-k))*
- [`6e78c9b`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/6e78c9bb573759fb26072aa646e326046bdfc9bf) - updated Amplitude Id setting during purchase *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`4c848ee`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/4c848eee4d4d21a837b4cb8054a16fcebc8fb32e) - updated fastlane file to handle both podspecs *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.18] - 2024-06-03
### :bug: Bug Fixes
- [`6e63338`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/6e6333856bdfd296569c2d7a2ce18a478aa41eb9) - fixing amplitude user id *(commit by [@fto-k](https://github.com/fto-k))*
- [`36bda9b`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/36bda9bde70199902d6f302e9485d5d1791ebbca) - added some logs *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`91d8a70`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/91d8a70feb2347de8228a884aaa5c3b1539de80b) - updating KovaleeSDKUI podspecs *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.17] - 2024-05-31
### :wrench: Chores
- [`1b73251`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/1b73251e95777fe4e95395e31f48ee20cb55a725) - bumped app SDK version *(commit by [@fto-k](https://github.com/fto-k))*
- [`65d1f37`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/65d1f37d2de31299eb7d526d798d4e3a407889fb) - created new KovaleeSDKUI podspecs *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.16] - 2024-05-31
### :wrench: Chores
- [`b9ea938`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/b9ea938736c9123a9533dc65bff46a2c7ed2196f) - enabled KovaleeSDKUI for cocoapods *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.15] - 2024-05-23
### :bug: Bug Fixes
- [`5dcd04a`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/5dcd04a92cb59fc7b808f3cc793d01fce0ce7972) - sync amplitudeId in RC *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.14] - 2024-05-22
### :bug: Bug Fixes
- [`f5fd15e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f5fd15e20d2f7729d2cfd62612d7d0d59cc67407) - fixing multiple ntt event sent *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.13] - 2024-05-16
### :bug: Bug Fixes
- [`6a94ef4`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/6a94ef406c975706448127997c10f50bfdf871c1) - fixed CV not sent if not set previously *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.12] - 2024-05-08
### :sparkles: New Features
- [`f6a0caa`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f6a0caad112c80aa71c122f96f44892d650df44a) - throws error if trying to fetch offers before adid has been synched *(commit by [@fto-k](https://github.com/fto-k))*
- [`4879153`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/4879153e89ac22c27e9e4350d22b1b17bc2235f5) - updated xcframework with new Purchase method *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.11] - 2024-05-03
### :sparkles: New Features
- [`ba587c3`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/ba587c3c29f900d8ec4d5c22a8746ca2a7ab875b) - send naAttDeactivate only if choice is actually deactivate *(commit by [@fto-k](https://github.com/fto-k))*

### :bug: Bug Fixes
- [`d6bf1e4`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/d6bf1e490aaa95c1c78ad548a12cf208728ae7b4) - fixed issue with sending double conversion value *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`cb8467b`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/cb8467bba1e6340a6eb6f116ff71e8a9083297d7) - updated SDK_VERSION string *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.9] - 2024-05-02
### :bug: Bug Fixes
- [`5859a9c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/5859a9cfd2851099a0bc71baac7843992fc09926) - fixed tracking authorization and related cv *(commit by [@fto-k](https://github.com/fto-k))*
- [`f8706a0`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f8706a0a9629ed34bb5621da2b9b5d48107f0b5f) - rolled back attribution *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.8] - 2024-04-30
### :sparkles: New Features
- [`236ae68`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/236ae68816cd23249491e8f333332d5a51d64752) - added Current SDK version to debug console *(commit by [@fto-k](https://github.com/fto-k))*
- [`5672eb4`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/5672eb4e2060a605c7ce1edac770c189d2eaf0fe) - new revenue cat async login function *(commit by [@fto-k](https://github.com/fto-k))*
- [`7607b61`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/7607b612e833bf16bac1dc6c634f80fd0e885d9c) - new revenue cat async login function *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.7] - 2024-04-30
### :bug: Bug Fixes
- [`c893a93`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/c893a93eeb4614b12208b9f5b6cd0ddc78e0689a) - events sequences tracking for early events *(commit by [@fto-k](https://github.com/fto-k))*
- [`d53ff2a`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/d53ff2ab2ff211a95ba68c2e32a8790f26c2418d) - events sequences tracking for early events *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.6] - 2024-04-24
### :bug: Bug Fixes
- [`0f9e129`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/0f9e129a4de679ae8a713f664820257c9ae95c85) - setting amplitude id to RC on app open *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.5] - 2024-04-22
### :sparkles: New Features
- [`8c59693`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/8c596937c7bb1922d26107552624d650477ebaab) - setting SDK version to amplitude user properties *(commit by [@fto-k](https://github.com/fto-k))*
- [`1b1dd45`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/1b1dd451c72cea5bf2faeff217d413036c343310) - set amplitude Id as RevenueCat default user Id during app start *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`636680e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/636680e43897206b040ed0f53ac511e947560fa1) - update podspecs *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.3] - 2024-04-15
### :wrench: Chores
- [`aa9afdc`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/aa9afdc6711d337b377c89ce760d840b37d99c86) - updated privacy manifest *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.2] - 2024-04-15
### :wrench: Chores
- [`3e4b0df`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/3e4b0df32bbd3edda88361b2c9adadb00d715679) - updated privacy manifest *(commit by [@fto-k](https://github.com/fto-k))*


## [1.9.0] - 2024-04-15
### :sparkles: New Features
- [`788c6f9`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/788c6f9f586d964c2bcd4230688fcfbc6de3f44e) - introducing new Paywall manager to handle paywalls *(commit by [@fto-k](https://github.com/fto-k))*

### :bug: Bug Fixes
- [`891976f`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/891976f4f9d280e140e6bc7efa1f1c5d0f0b078f) - PaywallManager protocol *(commit by [@fto-k](https://github.com/fto-k))*
- [`cd88f53`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/cd88f5303c33693d26e323e531f09ceccc7344af) - updated KovaleeFramework for PaywallKit *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`9d1f486`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/9d1f486c2fc071d1fa1beb815d9dcc429dc5c1c2) - updated privacy manifest *(commit by [@fto-k](https://github.com/fto-k))*
- [`02ef906`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/02ef90603b87ff5dc044c67b635416f7949fda26) - updated privacy manifest *(commit by [@fto-k](https://github.com/fto-k))*
- [`ee113cd`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/ee113cdfac59db2dbf39090ef6080e511263d17b) - updated privacy manifest *(commit by [@fto-k](https://github.com/fto-k))*
- [`63359cb`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/63359cb7c6671cf8675eb527901765eeb2593842) - updated min amplitude version for Privacy manifest *(commit by [@fto-k](https://github.com/fto-k))*
- [`fcf8af7`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/fcf8af79932240ddb965eb2bc7a3e91e5b6bab4d) - updated privacy info *(commit by [@fto-k](https://github.com/fto-k))*
- [`205d72e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/205d72eab4a91e08f4852791bd32f78e5919621a) - updated privacy manifest *(commit by [@fto-k](https://github.com/fto-k))*


## [1.8.4] - 2024-03-29
### :sparkles: New Features
- [`c87f1b1`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/c87f1b1bc5b6c863f9fd216d2558a38fbf37ec27) - events sequences files with date suffix can now be loaded *(commit by [@fto-k](https://github.com/fto-k))*
- [`33d039e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/33d039e0cd017866f9eefa103c37749384b31dd6) - display events sequences related data to Debug Console *(commit by [@fto-k](https://github.com/fto-k))*
- [`b9f1b27`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/b9f1b2760ca5d35ceebcbb302b0e10cab703c5e9) - updated DebugView accessibility *(commit by [@fto-k](https://github.com/fto-k))*
- [`e6380da`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/e6380da6cb38a5ccbb36c856f4f056977b69efd2) - updated SDK for privacy manifest conformance *(commit by [@fto-k](https://github.com/fto-k))*

### :bug: Bug Fixes
- [`863e87e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/863e87e0ae1e7e9fd64ec59b5b23eb2aa8d0f627) - small fix on events sequences logging *(commit by [@fto-k](https://github.com/fto-k))*
- [`a4beb16`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/a4beb169b669fd634522204dd5b25166e264b4ad) - show only last path component for events sequence file name *(commit by [@fto-k](https://github.com/fto-k))*
- [`92afb3d`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/92afb3d2751c0bb2542c10b1bee1d2bb028f2675) - small Console UI update *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`35dd64f`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/35dd64f8f31d658bf353d33614aec3d825f1bc8c) - small documentation amend *(commit by [@fto-k](https://github.com/fto-k))*


## [1.8.3] - 2024-02-28
### :sparkles: New Features
- [`43d07a2`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/43d07a23145495447c1453c862327b5b418e639b) - UI updates for Debug mode *(commit by [@fto-k](https://github.com/fto-k))*
- [`6246099`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/62460995cbe256f888dcea65091a6e44f958aa5a) - updated DebugConsole to be available in UIKit *(commit by [@fto-k](https://github.com/fto-k))*

### :bug: Bug Fixes
- [`105f4bc`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/105f4bc31b494b8416b0009fbb205853f0d343ff) - events sequences files can be loaded independently from app_code case *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`70d48c8`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/70d48c804cae42aab42efe396d780883d27dacb6) - integrated documentation for DebugConsole *(commit by [@fto-k](https://github.com/fto-k))*


## [1.8.2] - 2024-02-23
### :sparkles: New Features
- [`f0814f6`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f0814f6e66735b6d60058c11d23ad7bd2b6fd60f) - exposing method to detect if SDK is in debug mode *(commit by [@fto-k](https://github.com/fto-k))*


## [1.8.1] - 2024-02-19
### :bug: Bug Fixes
- [`313f51b`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/313f51bcbeada7d5471cd91aabc0360151168b48) - fixed bug in events sequences lite *(commit by [@fto-k](https://github.com/fto-k))*


## [1.8.0] - 2024-02-19
### :sparkles: New Features
- [`557b0aa`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/557b0aa87ef3c363d8169a943f5165fdd09cdac1) - implemented ViewModifier to load DebugView *(commit by [@fto-k](https://github.com/fto-k))*
- [`49f56e2`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/49f56e28d742dba8e54af676030a21faae21ec8f) - added a few data point to DebugView *(commit by [@fto-k](https://github.com/fto-k))*
- [`78f32b3`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/78f32b374e4380787422591318db8222d1908d50) - updated UI *(commit by [@fto-k](https://github.com/fto-k))*
- [`1bf338d`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/1bf338d804d4bfc402a192b4287a4344ea4d4263) - implemented set AB test flag *(commit by [@fto-k](https://github.com/fto-k))*
- [`0383307`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/0383307ec577b3ef7da7391edea3e62e7138a6b9) - exposing conversion value *(commit by [@fto-k](https://github.com/fto-k))*
- [`56d7491`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/56d7491d23209d62726b16015c77f98e7aab0168) - debug-mode conversion value test *(commit by [@fto-k](https://github.com/fto-k))*
- [`c79bacb`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/c79bacb966a696e57b48941497f9d99844dde705) - added print debug *(commit by [@fto-k](https://github.com/fto-k))*
- [`bbe04f3`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/bbe04f3f69cfb1c74537857445bfe773b7a44a96) - restored only ABTestValue *(commit by [@fto-k](https://github.com/fto-k))*
- [`9ccc81a`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/9ccc81a9089de4c2dca800a98b6c883b4f6bf6f2) - display current user active subscriptions *(commit by [@fto-k](https://github.com/fto-k))*
- [`acd39b1`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/acd39b1eee0fc41a850a3d123f06415f4c5c69cd) - showing current configuration *(commit by [@fto-k](https://github.com/fto-k))*
- [`f7151e8`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f7151e89ee852eafdbb449ef5548fbeb03dae78e) - UI fixes *(commit by [@fto-k](https://github.com/fto-k))*
- [`3f52777`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/3f527777f3e4b41658f9255a6555b2c6462fe12a) - changed purchase events properties *(commit by [@fto-k](https://github.com/fto-k))*
- [`9567d55`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/9567d55a7a97545da1b981d79e4d8bb32ce18ebe) - updated KovaleeFramework *(commit by [@fto-k](https://github.com/fto-k))*
- [`2706f4d`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/2706f4d866a15e4d77b7efa20261b7314e14e2f7) - implemented ViewModifier to load DebugView *(commit by [@fto-k](https://github.com/fto-k))*

### :bug: Bug Fixes
- [`51ca101`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/51ca101e72b56e0a929519277d8955cca2ace131) - fixed merge conflict *(commit by [@fto-k](https://github.com/fto-k))*


## [1.7.1] - 2024-02-09
### :sparkles: New Features
- [`1d31190`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/1d311908cef085d9bedc9e7c048ae23f08cdf6e5) - changed purchase events properties *(commit by [@fto-k](https://github.com/fto-k))*


## [1.7.0] - 2024-02-05
### :sparkles: New Features
- [`429f1b4`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/429f1b458070708478f2c8c2e6619d69a3b8e71d) - added xcframework for VisionOS *(commit by [@fto-k](https://github.com/fto-k))*
- [`bb710b8`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/bb710b8983a5470e145bff4e53707e0607425194) - added VisionOS Simulators support *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`961940e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/961940eb32677a047992a08eb47c703aeffb3a27) - testing support for vision-os *(commit by [@fto-k](https://github.com/fto-k))*
- [`874f369`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/874f3692cc7efebef31f77aca594eae32ffabf2e) - re-enabling cathalyst support *(commit by [@fto-k](https://github.com/fto-k))*


## [1.6.3] - 2024-01-31
### :sparkles: New Features
- [`5af5742`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/5af5742260fae9b467bdf5abdd07d97e0a66e6e4) - disabled IDFV tracking for GDPR reasons *(commit by [@fto-k](https://github.com/fto-k))*


## [1.6.2] - 2024-01-24
### :bug: Bug Fixes
- [`adc8cfa`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/adc8cfac528d1df22c7bd8d9304bdd5f71b921ae) - removed remote fetch on SDK initialization *(commit by [@fto-k](https://github.com/fto-k))*


## [1.6.1] - 2024-01-24
### :sparkles: New Features
- [`c01e5e1`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/c01e5e18054f077bcf920bca873afbbc42a26893) - new method to expose local ab test value *(commit by [@fto-k](https://github.com/fto-k))*

### :bug: Bug Fixes
- [`e6749eb`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/e6749eb9a2967124bfc57042f46468e7a1c4f202) - when ab value is manually set, remote config shouldn t update default values *(commit by [@fto-k](https://github.com/fto-k))*
- [`d03ded9`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/d03ded9b122e8c85879db9dfa6033429c59ad369) - setting AB value to user defaults as String instead of Data *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`aeb742e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/aeb742e60524b322d5e831ad011ab623a92b7af5) - amended fastfile *(commit by [@fto-k](https://github.com/fto-k))*
- [`283c8fb`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/283c8fb537c83123b83dde103ecfe79c62d8cb03) - removed debugging logs *(commit by [@fto-k](https://github.com/fto-k))*


## [1.6.0] - 2024-01-19
### :sparkles: New Features
- [`ef33315`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/ef33315b6071f0d45d0697b8f3944e757ff3377d) - new functions to set ab test value and set remote config timeout *(commit by [@fto-k](https://github.com/fto-k))*
- [`02aed2e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/02aed2eafa6cae2373b10699294dae11046682ec) - set timeout for remote config fetching *(commit by [@fto-k](https://github.com/fto-k))*


## [1.5.9] - 2024-01-12
### :bug: Bug Fixes
- [`2c96587`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/2c96587061273bb2e99a9dd9e9a3fceab1f1ebb8) - rolled back async abTestValue *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`0fb65eb`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/0fb65eba4d7357ed384ee5ab1fe995601cee53c5) - updated fastfile *(commit by [@fto-k](https://github.com/fto-k))*


## [1.5.6] - 2023-12-05
### :bug: Bug Fixes
- [`11822a0`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/11822a045b41ce737ac5cf14372321078097f1b1) - rolling back RemoteConfig fetching *(commit by [@fto-k](https://github.com/fto-k))*


## [1.5.5] - 2023-11-14
### :bug: Bug Fixes
- [`17fb110`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/17fb1104265f1f17906929c4e2adeda11924263c) - Payment restore should now throw an error in case of failure *(commit by [@fto-k](https://github.com/fto-k))*


## [1.5.4] - 2023-11-13
### :sparkles: New Features
- [`9125e24`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/9125e2477b53a20b427ad4102c20482c6d797b97) - new purchase methods *(commit by [@fto-k](https://github.com/fto-k))*


## [1.5.3] - 2023-11-08
### :bug: Bug Fixes
- [`b82a59c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/b82a59c170479678d8110559166a1060c83f6000) - abValue retrieval should still be async *(commit by [@fto-k](https://github.com/fto-k))*


## [1.5.2] - 2023-11-08
### :sparkles: New Features
- [`2eef111`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/2eef111b8d0f700cb4a1e345d9bfd3a2e81f8224) - updating RemoteConfig initialization and function asynchronicity *(commit by [@fto-k](https://github.com/fto-k))*
- [`e3ad3cb`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/e3ad3cb576473d371afbbf23b1952dd9ee3e40a0) - removed asyncronocity for remote values *(commit by [@fto-k](https://github.com/fto-k))*
- [`8ca8438`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/8ca84386bbc9a950d3104dab618d64383f27ba89) - removed asynchonicity *(commit by [@fto-k](https://github.com/fto-k))*
- [`0955403`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/0955403596269c11415401b9ffaabf754b4f3f6f) - removed asynchonicity from abValue *(commit by [@fto-k](https://github.com/fto-k))*


## [1.5.0] - 2023-11-06
### :sparkles: New Features
- [`e88a1d9`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/e88a1d9adcba0d25b846516e7e56f8ea858b3c88) - created new TaggingPlanLiteEvent enum with lite events to be tracked *(commit by [@fto-k](https://github.com/fto-k))*


## [1.4.3] - 2023-10-03
### :bug: Bug Fixes
- [`755764a`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/755764a8fec38d59daa4ec37b7ec265508b51b03) - appInstallationDate and appOpeningCount are now static functions *(commit by [@fto-k](https://github.com/fto-k))*


## [1.4.2] - 2023-10-03
### :sparkles: New Features
- [`1d1978c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/1d1978c6990377f86ac164f29d173a7e8431055d) - implemented extra safety guard for stopping app opening events in case tracking is disabled *(commit by [@fto-k](https://github.com/fto-k))*


## [1.4.1] - 2023-10-03
### :sparkles: New Features
- [`a3d193e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/a3d193e7c2147605d68620352ab3bf45eb42bfea) - new methods to retrieve app installation date and app opeining count *(commit by [@fto-k](https://github.com/fto-k))*


## [1.4.0] - 2023-09-21
### :sparkles: New Features
- [`19ef312`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/19ef3126551f1babe6446023f398a31f1b16e64b) - implemented new tracking optout function *(commit by [@fto-k](https://github.com/fto-k))*
- [`4afcbc7`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/4afcbc7e0d1502f8f67caa7a04c6d2280f584268) - updated KFramework for enabling tracking optout *(commit by [@fto-k](https://github.com/fto-k))*
- [`2c7c1a0`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/2c7c1a0b70a15b8f24ce8ad8d57d64de22821bfa) - added new method to create Duration enum from Int values *(commit by [@fto-k](https://github.com/fto-k))*
- [`fdc859d`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/fdc859d76076c57abc2cf36675c83b89ca115c4b) - set tracking enabled on tracker initialization *(commit by [@fto-k](https://github.com/fto-k))*
- [`9c230c2`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/9c230c2d8535092ba33a24d4249972a8a441101d) - added tracking opt out for remote config *(commit by [@fto-k](https://github.com/fto-k))*
- [`0e69027`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/0e69027f51fc596a37e7b4c0a2e949067ae18535) - added tracking enabling capabilities to KovaleeAds *(commit by [@fto-k](https://github.com/fto-k))*
- [`c873c2f`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/c873c2fac42697342a6a52f3a4ee3d780d49332f) - enabled tracking switch for attribution *(commit by [@fto-k](https://github.com/fto-k))*
- [`d731326`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/d7313262d4fcf436ace03fd8fab0f03cdcfcb9de) - disabled events sequences if tracking is disabled *(commit by [@fto-k](https://github.com/fto-k))*
- [`45ed24d`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/45ed24da84a2e3fb04d4ce20a208bcf65a48f826) - added protocol default implementation to avoid other Kovalee modules to complain *(commit by [@fto-k](https://github.com/fto-k))*
- [`7a6915f`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/7a6915feb05d25bb1486707d87bf6fee876ab14f) - bumped podspec version *(commit by [@fto-k](https://github.com/fto-k))*


## [1.3.6] - 2023-09-20
### :bug: Bug Fixes
- [`9882077`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/9882077bb7aa3fa945e2297ea2ea814167c765f0) - Duration inDays computed property is now public *(commit by [@fto-k](https://github.com/fto-k))*


## [1.3.5] - 2023-09-20
### :sparkles: New Features
- [`3e4fd51`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/3e4fd518aa052b1c89532bf174a4d907b1e35d4a) - updated subscription duration functions input parameter to be an Enum instead of int *(commit by [@fto-k](https://github.com/fto-k))*


## [1.3.4] - 2023-09-14
### :sparkles: New Features
- [`a692085`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/a692085cdc875a209c915da0d38dc6f32f28bab0) - removed FB ad Configuration from KovaleeAds protocol *(commit by [@fto-k](https://github.com/fto-k))*
- [`2a4e291`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/2a4e291754c26b754123c5595ab2d5e41795dd5a) - remove FB Ads configuration from public interface *(commit by [@fto-k](https://github.com/fto-k))*
- [`581d7fa`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/581d7faad0b285f44fe9b21be748daddfedad187) - updated rewarded ad function to return actual reward *(commit by [@fto-k](https://github.com/fto-k))*


## [1.3.3] - 2023-09-07
### :sparkles: New Features
- [`297bcc0`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/297bcc08f0463fae166590fa1c2f80c88bfe4231) - new framework version with new method for purchasing subscriptions *(commit by [@fto-k](https://github.com/fto-k))*


## [1.3.2] - 2023-08-31
### :sparkles: New Features
- [`4165b21`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/4165b21208f075184da6b1813d36bec4ad112765) - enabled Amplitude IP tracking *(commit by [@fto-k](https://github.com/fto-k))*


## [1.3.1] - 2023-08-24
### :bug: Bug Fixes
- [`fd2d43e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/fd2d43ec3d1951e062e4b0c86b56421fb5d441ad) - new Framework version for fixing automatically user-id setting *(commit by [@fto-k](https://github.com/fto-k))*


## [v1.2.4] - 2023-08-09
### :bug: Bug Fixes
- [`8353691`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/83536911c1d69f7d72915932fb903c9299cee2ce) - cv value on first app open *(commit by [@fto-k](https://github.com/fto-k))*


## [v1.2.3] - 2023-08-09
### :bug: Bug Fixes
- [`209049c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/209049cc46f131995c3c72bc58be6075ce7f5c7e) - sending conversion value on first app open *(commit by [@fto-k](https://github.com/fto-k))*


## [v1.2.2] - 2023-08-03
### :sparkles: New Features
- [`473215d`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/473215d75fbab6f2eb92aa34594af975a33343bb) - added podspec file *(commit by [@fto-k](https://github.com/fto-k))*
- [`1c626b2`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/1c626b275f3ef57cb7ff63b7fb3cf422c5e19a29) - updated Amplitud to 0.4.7 *(commit by [@fto-k](https://github.com/fto-k))*
- [`203e8d0`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/203e8d0fe3f06601e17b3ecf113f173deed2325b) - implemented functions to retrieve Adjust adid and Amplitude User and Device Id *(commit by [@fto-k](https://github.com/fto-k))*
- [`fbe7358`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/fbe7358cf190eaa6f19d0c62d50025c62287b552) - removed Amplitude dependency *(commit by [@fto-k](https://github.com/fto-k))*
- [`94818d0`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/94818d0ac6591101353924588fc9c05f9d31808c) - restored KovaleeFramework *(commit by [@fto-k](https://github.com/fto-k))*
- [`f7178db`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f7178db5efd0ae6d57e6351ca85e339914ad2055) - new KovaleeFramework version *(commit by [@fto-k](https://github.com/fto-k))*
- [`dc3ad2c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/dc3ad2c7add6807af14d50934e1200b3e676168c) - implemented functions to retrieve Adjust adid and Amplitude User and Device Id *(commit by [@fto-k](https://github.com/fto-k))*
- [`8d333f9`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/8d333f9e5438e0b4a9b83cdc4ee9c8a8c00ce7f0) - added podspec file *(commit by [@fto-k](https://github.com/fto-k))*
- [`8547040`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/85470408a96b1a7ef56fc091bf9097e9764ee014) - created AmplitudeWrapper duplicate file for cocoapods to support different namespace for Amplitude *(commit by [@fto-k](https://github.com/fto-k))*

### :bug: Bug Fixes
- [`0dee4b5`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/0dee4b5075576cbeefb0cb75fb4c11a53724033d) - fixed setUserIsPremium function *(commit by [@fto-k](https://github.com/fto-k))*
- [`add9e8e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/add9e8e6ae6468539f988004e6d4a404eb95d803) - fixed setUserIsPremium function *(commit by [@fto-k](https://github.com/fto-k))*
- [`46a1fc9`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/46a1fc922c45ae20117a9cb5c1557fc5a73d3c5c) - fixing setting user is premium on RC customerInfo call *(commit by [@fto-k](https://github.com/fto-k))*
- [`f118223`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f1182236ad998b8eddf786d0ea14b2545e5c1b26) - fixed setUserIsPremium function *(commit by [@fto-k](https://github.com/fto-k))*
- [`6f03fa3`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/6f03fa36a774159c4db42e483e99569e271b70a1) - fixed setUserIsPremium function *(commit by [@fto-k](https://github.com/fto-k))*
- [`15e5bed`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/15e5bed4701506e998bf993cd2c4905dc2b002b5) - fixing setting user is premium on RC customerInfo call *(commit by [@fto-k](https://github.com/fto-k))*
- [`fd2c050`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/fd2c05044fa800f832f4076c65a737bdbde339f1) - possible fix for setting user id *(commit by [@fto-k](https://github.com/fto-k))*
- [`5c04eed`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/5c04eed67c31c8e4200bee313a9523828dfb7a62) - updated setDefualtUserId to set it to nil if none is found *(commit by [@fto-k](https://github.com/fto-k))*
- [`ed39553`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/ed395537455cd2a514c06ec63f118621c54ced02) - new KovaleeFramework release with fix for amplitude user id *(commit by [@fto-k](https://github.com/fto-k))*
- [`de7640e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/de7640e16b97a69e7c2d6542316db1f732837ab1) - fixed cocoapod fix path *(commit by [@fto-k](https://github.com/fto-k))*


## [v1.2.1] - 2023-08-02
### :sparkles: New Features
- [`a661804`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/a661804de8be23d3ae80e3589ed0422ecc69b725) - removing .swiftpm cached *(commit by [@fto-k](https://github.com/fto-k))*

### :bug: Bug Fixes
- [`552271f`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/552271f3c56d19ec823a3163e19ff3a7bc3a6657) - possible fix for setting user id *(commit by [@fto-k](https://github.com/fto-k))*
- [`19beee2`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/19beee29f315ad05ea07a1927dc0abeaf04fb458) - updated setDefualtUserId to set it to nil if none is found *(commit by [@fto-k](https://github.com/fto-k))*
- [`35f847a`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/35f847a933e87cce6af7d26be384925ee962d01c) - new KovaleeFramework release with fix for amplitude user id *(commit by [@fto-k](https://github.com/fto-k))*


>>>>>>> master
## [v1.2.0] - 2023-08-01
### :sparkles: New Features
- [`5cb83ca`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/5cb83ca2809d451a7a7e997c55f93642778ef91d) - started splitting framework *(commit by [@fto-k](https://github.com/fto-k))*
- [`205cf3c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/205cf3cff6d568982b66dc6b6188d8fa0ce2da2c) - moved Adjust to new target KovaleeAttribution *(commit by [@fto-k](https://github.com/fto-k))*
- [`d0f320f`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/d0f320f6e17e8c94a7c31b77b25b960796342738) - creating Adjust instance if not present yet *(commit by [@fto-k](https://github.com/fto-k))*
- [`f11c67c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f11c67cbb1b75de279e7517580dcf0e4c5081703) - creating Adjust instance if not present yet *(commit by [@fto-k](https://github.com/fto-k))*
- [`03f5dc1`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/03f5dc13b7a4e484ca3f851f22381742b57e6aae) - creating Adjust instance if not present yet *(commit by [@fto-k](https://github.com/fto-k))*
- [`0bb1993`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/0bb1993dbccd3adc024ebf298725c39b529b6a8e) - creating Adjust instance if not present yet *(commit by [@fto-k](https://github.com/fto-k))*
- [`7baef6c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/7baef6c4e14763bd4f7fe09aa3c81546a0b0b09c) - creating Adjust instance if not present yet *(commit by [@fto-k](https://github.com/fto-k))*
- [`9ea19e6`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/9ea19e66a72a08cd825f470e9b029c694b56f867) - implemented functions to retrieve Adjust adid and Amplitude User and Device Id *(commit by [@fto-k](https://github.com/fto-k))*
- [`e516d4e`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/e516d4eee412f116882b7eede6bd1a4310ff9d36) - started splitting framework *(commit by [@fto-k](https://github.com/fto-k))*
- [`a8542e3`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/a8542e3732b948bfa80f18706510bb48648cbf11) - moved Adjust to new target KovaleeAttribution *(commit by [@fto-k](https://github.com/fto-k))*
- [`36b6e98`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/36b6e9849d41b496c901a900c513f158cf2be7f2) - creating Adjust instance if not present yet *(commit by [@fto-k](https://github.com/fto-k))*
- [`098c568`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/098c568dbde392abace93a68fbef930234edbcd2) - moved Purchases code to KovaleePurchases Target *(commit by [@fto-k](https://github.com/fto-k))*
- [`863e6fc`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/863e6fcb01416d810dea17021135ba111686e206) - moved Firebase code to specific target KovaleeRemoteConfig *(commit by [@fto-k](https://github.com/fto-k))*
- [`a0a2073`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/a0a207382fa44eb7bfe23b53ea1a784eaa2ffc70) - moved Ads code to KovaleeAds *(commit by [@fto-k](https://github.com/fto-k))*
- [`77f2878`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/77f2878e0737608d0108fc48877a4f03b38d917a) - updated to the latest framework version *(commit by [@fto-k](https://github.com/fto-k))*
- [`efb778f`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/efb778febd5ce6bde601178b3efeccbed4407b57) - removed Amplitude dependency *(commit by [@fto-k](https://github.com/fto-k))*
- [`13962f8`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/13962f8b979f6b81cae4d8dae1e8b14187487a51) - restored KovaleeFramework *(commit by [@fto-k](https://github.com/fto-k))*
- [`ee4ca8d`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/ee4ca8d6a1166b54385712f97b4654f38acb2275) - moved RemoteConfig to specific Package *(commit by [@fto-k](https://github.com/fto-k))*
- [`5a2a46a`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/5a2a46aff496bf07a728bea73bd3e18238aded8a) - moved Purchases to specific package *(commit by [@fto-k](https://github.com/fto-k))*
- [`50b41f8`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/50b41f85e700dfb9a9e32b0f3b1a63a38cd085a8) - moved Attribution to specific package *(commit by [@fto-k](https://github.com/fto-k))*
- [`95dc5b3`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/95dc5b3042db342cb9d3ba47f0e343df47d13bdc) - updated Amplitud to 0.4.7 *(commit by [@fto-k](https://github.com/fto-k))*
- [`630feb8`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/630feb89706cebb7e11c709f1501b63dc22a8dcc) - implemented functions to retrieve Adjust adid and Amplitude User and Device Id *(commit by [@fto-k](https://github.com/fto-k))*
- [`f96ead0`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f96ead08dec212c4868692a5fd789c0d61424ba1) - removed Amplitude dependency *(commit by [@fto-k](https://github.com/fto-k))*
- [`a8a67f6`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/a8a67f6fdd1b66ec34982b0ed4a5719ecf93efcc) - restored KovaleeFramework *(commit by [@fto-k](https://github.com/fto-k))*
- [`f1f4a6c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/f1f4a6c4726456925cd09c8500780e3da784f839) - new KovaleeFramework version *(commit by [@fto-k](https://github.com/fto-k))*

### :bug: Bug Fixes
- [`d2121b1`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/d2121b1f08079bac2f4429cc1aab5931fb1e98a9) - rebased on master *(commit by [@fto-k](https://github.com/fto-k))*
- [`b425b8f`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/b425b8f876e3aa81263d26351601baf757366eb2) - fixed setUserIsPremium function *(commit by [@fto-k](https://github.com/fto-k))*
- [`d33266c`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/d33266c94381d06b5c0ae443dcd112bbda4ad99f) - fixed setUserIsPremium function *(commit by [@fto-k](https://github.com/fto-k))*
- [`9495db2`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/9495db2ee25c0b33018fbb83b388dc4fc4893b93) - fixing setting user is premium on RC customerInfo call *(commit by [@fto-k](https://github.com/fto-k))*


## [v1.0.2] - 2023-07-27
### :bug: Bug Fixes
- [`993b5fc`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/993b5fcded6240ada61886bb207f9d2f7f7b6abe) - fixed setUserIsPremium function *(commit by [@fto-k](https://github.com/fto-k))*
- [`15931f2`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/15931f29d5b8d8a9a4dd8b0640304c573ef3a51f) - fixed setUserIsPremium function *(commit by [@fto-k](https://github.com/fto-k))*
- [`150464a`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/150464a9e7f543df138af71290d023221b368843) - fixing setting user is premium on RC customerInfo call *(commit by [@fto-k](https://github.com/fto-k))*


## [v1.0.1] - 2023-07-26
### :sparkles: New Features
- [`69235d0`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/69235d01f4d43cc121a2f818de18c94fe62f3328) - implemented functions to retrieve Adjust adid and Amplitude User and Device Id *(commit by [@fto-k](https://github.com/fto-k))*


## [v1.0.0] - 2023-07-20
### :sparkles: New Features
- [`348f2d0`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/348f2d05fc3c217b95f76d7899b48c20df4a969d) - introduced github action to create release from tag *(commit by [@fto-k](https://github.com/fto-k))*
- [`1a17867`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/1a17867f89dbab99f1c0fe5de161d1ab8a7f5454) - implemented new algorithm to calculate the conversion value for apps not yet mature *(commit by [@fto-k](https://github.com/fto-k))*

### :wrench: Chores
- [`2fd04b1`](https://github.com/cotyapps/Kovalee-iOS-SDK/commit/2fd04b1f494757c9c482a3a80333e230a30a7d3a) - removed deprecated method for RevenueCat *(commit by [@fto-k](https://github.com/fto-k))*


[v1.0.0]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/0.9.13...v1.0.0
[v1.0.1]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/v1.0.0...v1.0.1
[v1.0.2]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/v1.0.1...v1.0.2
[v1.2.0]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/v1.0.2...v1.2.0
[v1.2.1]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/v1.2.0...v1.2.1
[v1.2.2]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/v1.2.1...v1.2.2
[v1.2.3]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.2.3...v1.2.3
[v1.2.4]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/v1.2.3...v1.2.4
[1.3.1]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.3.0...1.3.1
[1.3.2]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.3.1...1.3.2
[1.3.3]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.3.2...1.3.3
[1.3.4]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.3.3...1.3.4
[1.3.5]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.3.4...1.3.5
[1.3.6]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.3.5...1.3.6
[1.4.0]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.3.6...1.4.0
[1.4.1]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.4.0...1.4.1
[1.4.2]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.4.1...1.4.2
[1.4.3]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.4.2...1.4.3
[1.5.0]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.4.4...1.5.0
[1.5.2]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.5.1...1.5.2
[1.5.3]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.5.2...1.5.3
[1.5.4]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.5.3...1.5.4
[1.5.5]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.5.4...1.5.5
[1.5.6]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.5.5...1.5.6
[1.5.9]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.5.8...1.5.9
[1.6.0]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.5.9...1.6.0
[1.6.1]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.6.0...1.6.1
[1.6.2]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.6.1...1.6.2
[1.6.3]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.6.2...1.6.3
[1.7.0]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.6.3...1.7.0
[1.7.1]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.7.0...1.7.1
[1.8.0]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.7.1...1.8.0
[1.8.1]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.8.0...1.8.1
[1.8.2]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.8.1...1.8.2
[1.8.3]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.8.2...1.8.3
[1.8.4]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.8.3...1.8.4
[1.9.0]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.8.4...1.9.0
[1.9.2]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.1...1.9.2
[1.9.3]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.2...1.9.3
[1.9.5]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.4...1.9.5
[1.9.6]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.5...1.9.6
[1.9.7]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.6...1.9.7
[1.9.8]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.7...1.9.8
[1.9.9]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.8...1.9.9
[1.9.11]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.10...1.9.11
[1.9.12]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.11...1.9.12
[1.9.13]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.12...1.9.13
[1.9.14]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.13...1.9.14
[1.9.15]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.14...1.9.15
[1.9.16]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.15...1.9.16
[1.9.17]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.16...1.9.17
[1.9.18]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.17...1.9.18
[1.9.19]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.18...1.9.19
[1.9.20]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.19...1.9.20
[1.9.21]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.20...1.9.21
[1.9.22]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.21...1.9.22
[1.10.0]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.9.22...1.10.0
[1.10.1]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.10.0...1.10.1
[1.10.3]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.10.2...1.10.3
[1.10.4]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.10.3...1.10.4
[1.10.5]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.10.4...1.10.5
[1.10.7]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.10.6...1.10.7
[1.10.8]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.10.7...1.10.8
[1.10.9]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.10.8...1.10.9
[1.11.0]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.10.9...1.11.0
[1.12.0]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.11.1...1.12.0
[1.12.1]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.12.0...1.12.1
[1.12.3]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.12.2...1.12.3
[1.12.4]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.12.3...1.12.4
[1.12.5]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.12.4...1.12.5
[2.0.0]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/1.12.5...2.0.0
[2.0.1]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/2.0.0...2.0.1
[2.0.3]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/2.0.2...2.0.3
[2.0.4]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/2.0.3...2.0.4
[2.0.6]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/2.0.5...2.0.6
[2.0.7]: https://github.com/cotyapps/Kovalee-iOS-SDK/compare/2.0.6...2.0.7
