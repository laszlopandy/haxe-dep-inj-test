
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