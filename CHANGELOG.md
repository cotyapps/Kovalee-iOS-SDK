# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


<<<<<<< HEAD
=======
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