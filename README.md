# EmojiWrappers 
A funny collection of handy Swift wrappers

<img width="396" src="https://github.com/mrgradyed/EmojiWrappers/assets/2436636/c87bad99-4397-4814-ade4-a7f74a2b2a4c">

## 🐮

A property wrapper that provides the COW 🐮 (Copy-On-Write) optimization for any Value type (https://github.com/apple/swift/blob/main/docs/OptimizationTips.rst#advice-use-copy-on-write-semantics-for-large-values).


```
    struct MyStruct: Equatable {
        var property: String
    }

    struct AnotherStruct: Equatable {
        // the value of this property won't be duplicated on READ (assignment, passing, etc..), saving some resources.
        @🐮 var property: MyStruct
    }
```

## 🟰

A property wrapper that allows to ignore a property when performing an equality check by assuming it's always equal.

```
    public struct MyStruct: Equatable {
        @IgnoreEquatable var propertyA: Int // this property will be skipped in any equality check
        var propertyB: Int // this will be compared in all equality checks
    }

    // this equality check succeeds, although property A is different
    MyStruct(propertyA: 1, propertyB: 3) == MyStruct(propertyA: 2, propertyB: 3)

    // this equality check fails, since property B is different and not wrapped
    MyStruct(propertyA: 1, propertyB: 3) == MyStruct(propertyA: 1, propertyB: 4)

```


##### All emoji wrappers come with conformance to Equatable, Encodable and Decodable. And are 100% covered by unit tests.
