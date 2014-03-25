haxe-dep-inj-test
=================

Experiments for dependency injection in Haxe

Build it with Haxe 3.1.1
-------------------------
```
haxe test.hxml
open test.html
```

How it works
------------

All injectable dependencies are given as arguments to the constructor. To indicate which arguments should be automatically injected, you must create a static variable called `Inject`.
```haxe
class NeedsHeater {
	static var Inject = [HeaterImpl];
	public function new(heater:Heater, anotherArg:Int) {

	}
}
```

To initialize your class with injected dependencies, first create an `Injector` and then call the `get` method with the class.
```haxe
var inj = new Injector();
var nh = inj.get(NeedsHeater, [5]);
```
If the class constructor takes parameters which are not injected, they are passed in a list after the class.

How to mock
-----------

Simply pass in the name of the class which you want to be used instead. It will be injected in place of any other class which implements the same interface.
```haxe
var inj = new Injector([MockHeater]);
```
See [the code][1] for details.
[1]: https://github.com/laszlopandy/haxe-dep-inj-test/blob/master/Test.hx#L90