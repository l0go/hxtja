package tja;

@:structInit
class ChartHeader {
	public var title: Map<RegionTag, String> = [];
	public var subtitle: Map<RegionTag, String> = [];
	
	public var maker: Null<String>;
	public var genre: Null<String>;
	
	public var song: Null<Song>;
	public var game: Null<Game>;
	public var preview: Null<Preview>;

	public function new() {
		this.game = new Game();
		this.song = new Song();
		this.preview = new Preview();
	}
}

@:structInit 
class Game {
	public var style: Null<String>;
	public var soundEffectsVolume: Null<Int> = 100;

	public function new() {}
}

@:structInit
class Song {
	public var file: Null<String>;
	public var volume: Null<Int> = 100;
	public var bpm: Null<Float> = 120.0;
	public var offset: Null<Float>;

	public function new() {}
}

@:structInit
class Preview {
	public var demonstrationStart: Null<Float>;

	public function new() {}
}
