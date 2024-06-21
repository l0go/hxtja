package tja.macros;

import haxe.macro.Context;
import haxe.macro.Expr;

using StringTools;

class RegionTagBuilder {
	macro static public function build(): Array<Field> {
		var enumValues: Array<Field> = [];
	
		var filePath = Context.resolvePath(Context.getPosInfos(Context.currentPos()).file);
		filePath = filePath.substring(0, filePath.lastIndexOf("/")) + "/languages.json";
		final jsonFile = sys.io.File.getContent(filePath);
		final json = haxe.Json.parse(jsonFile);

		for (key in Reflect.fields(json.main.en.localeDisplayNames.languages)) {
			enumValues.push(makeEnumField(key.replace("-", "_"), FVar(null, null)));
		}
		return enumValues;
	}

	static function makeEnumField(name: String, kind) {
		return {
			name: name,
			doc: null,
			meta: [],
			access: [],
			kind: kind,
			pos: Context.currentPos()
		}
	}
}
