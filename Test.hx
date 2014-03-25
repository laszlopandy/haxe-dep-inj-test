
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

class Test {
	public static function main() {
		var inj = new Injector();
		// Comment out next line to mock out HeaterImpl and Logging
		// inj = new Injector([MockHeater]);
		var cm = inj.get(CoffeeMachine, [new CoffeeModel()]);
	}
}