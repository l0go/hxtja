package tja;

enum abstract NoteType(Int) from Int to Int {
	final empty = 0;
	final smallDon = 1;
	final smallKat = 2;
	final largeDon = 3;
	final largeKat = 4;
	final smallDrumRollStart = 5;
	final largeDrumRollStart = 6;
	final balloonStart = 7;
	final end = 8;
	final largeBalloonStart = 9;
}

class Note {
	public var type: NoteType;
	public var scroll = 1.0;
	public var measureLength: Float = 0.0;
	public var gogo: Bool = false;

	public function new(?type: NoteType = empty) {
		this.type = type;
	}
}
