
interface Heater {
	public function turnOn():Void;
}

class MockHeater implements Heater {
	public function new () {}
	public function turnOn() {
		trace("Heater mocked on");
	}
}

class Logging {
	public function new() {
		trace("With logging");
	}
}

class HeaterImpl implements Heater {
	static var Inject = [Logging];
	public function new (logging:Logging) {}
	public function turnOn() {
		trace("Heater on");
	}
}

class CoffeeModel {
	public function new() {}
	public function getType() {
		return "French press";
	}
}

class CoffeeMachine {
	static var Inject = [HeaterImpl];
	public function new(heater:Heater, model:CoffeeModel) {
		heater.turnOn();
		trace("Coffee maker ready: " + model.getType());
	}
}

class Injector {
	var overrides:Array<Class<Dynamic>>;
	public function new(overrides:Array<Class<Dynamic>>=null) {
		this.overrides = if (overrides != null) overrides else [];
	}

	function createDep<T>(klass:Class<T>, extraArgs:Array<Dynamic>):T {
		var deps:Array<Class<Dynamic>> = untyped klass.Inject;
		var args = [];
		if (deps != null) {
			for (dep in deps) {
				args.push(this.get(dep));
			}
		}

		if (extraArgs != null) {
			args = args.concat(extraArgs);
		}

		return Type.createInstance(klass, args);
	}

	function getProvides<T>(klass:Class<T>):T {
		var ifaces:Array<Dynamic> = untyped klass.__interfaces__;
		if (ifaces != null && ifaces.length == 1) {
			return ifaces[0];
		}
		return null;
	}

	public function get<T>(klass:Class<T>, args:Array<Dynamic>=null):T {
		var iface = getProvides(klass);
		if (iface != null) {
			for (o in overrides) {
				if (iface == getProvides(o)) {
					return this.createDep(o, args);
				}
			}
		}

		return this.createDep(klass, args);
	}
}

class Test {
	public static function main() {
		var inj = new Injector();
		// Comment out next line to mock out HeaterImpl and Logging
		// inj = new Injector([MockHeater]);
		var cm = inj.get(CoffeeMachine, [new CoffeeModel()]);
	}
}