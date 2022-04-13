# Synchronize Objects

![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)
[![Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=flat)](LICENSE.md)

Provides helper objects for generialzing object synchronization
It allows others to swap between different synchronization objects like NSLock, DispatchQueue and OperationQueue

## Requirements

* Xcode 9+ (If working within Xcode)
* Swift 4.0+

## Usage

### Lockable
```swift
let lock: Lockable = .... (can be NSLock, DispatchQueue, OperationQueue)
lock.lockingFor {

}
```

### SyncObj
```swift
let syncObj = SyncObj<Bool, NSLock>(object: true, lock: NSLock())

/// Safely read from object
_ = syncObj.object
/// Safely write to object
syncObj.object = false
```

## Author

* **Tyler Anger** - *Initial work* 

## License

*Copyright 2022 Tyler Anger*

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[HERE](LICENSE.md) or [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

