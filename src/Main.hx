package;

class Main {
	static function main() {
		final parser = new tja.Parser();
		final file = sys.io.File.getContent("./samples/Nosferatu.tja");
		var chart = parser.parse(file);
		trace(haxe.Json.stringify(chart, null, "\t"));
	}
}
