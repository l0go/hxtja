package tja;

import haxe.iterators.StringIterator;
using StringTools;

class Parser {
	public function new() {}
	public function parse(contents: String): Chart {
		var chart = new Chart();
		// These are temporary variables used while constructing the chart
		var course: Course = null;
		var measure = null;
		var timeSignature = [4, 4];
		var bpm: Float = 120.0;
		var scroll: Float = 1.0;
		var delay: Float = 0.0;
		var gogo = false;

		for (line in contents.split("\n")) {
			var splitLine = line.split(":");
			if (splitLine.length > 1) {
				switch (splitLine) {
					case ["TITLE", languageTag, title]:
						chart.header.title.set(languageTag, title);
					case ["TITLE", title]:
						chart.header.title.set(RegionTag.ja, title);
					case ["SUBTITLE", languageTag, subtitle]:
						chart.header.subtitle.set(cast languageTag, subtitle);
					case ["SUBTITLE", subtitle]:
						chart.header.subtitle.set(RegionTag.ja, subtitle);
					case ["MAKER", maker]:
						chart.header.maker = maker;
					case ["GENRE", genre]:
						chart.header.genre = genre;
					case ["SEVOL", soundEffectsVolume]:
						chart.header.game.soundEffectsVolume = Std.parseInt(soundEffectsVolume);
					case ["WAVE", songFile]:
						chart.header.song.file = songFile;
					case ["OFFSET", offset]:
						chart.header.song.offset = Std.parseFloat(offset);
					case ["SONGVOL", songVolume]:
						chart.header.song.volume = Std.parseInt(songVolume);
					case ["BPM", bpm]:
						chart.header.song.bpm = Std.parseFloat(bpm);
					case ["DEMOSTART", previewStart]:
						chart.header.preview.demonstrationStart = Std.parseFloat(previewStart);
					case ["COURSE", courseValue]:
						course = new Course();
						course.course = Std.parseInt(courseValue);
						measure = new Measure();
						timeSignature = [4, 4];
						bpm = 60.0;
						scroll = 1.0;
						delay = 0.0;
						gogo = false;
					case ["LEVEL", level]:
						course.level = Std.parseInt(level);
					case ["STYLE", style]:
						chart.header.game.style = style;
					case ["BALLOON", balloonHitAmount] | ["BALLOONNOR", balloonHitAmount] | ["BALLOONEXP", balloonHitAmount] | ["BALLOONMAS", balloonHitAmount]:
						for (val in balloonHitAmount.split(",")) {
							course.balloons.push(Std.parseInt(val));
						}
					case ["SCOREINIT", scoreInitial]:
						course.initialScore = Std.parseInt(scoreInitial);
					case ["SCOREDIFF", scoreDifference]:
						course.scoreDifference = Std.parseInt(scoreDifference);
					default:
						trace('I am confused, I have never heard of the ${splitLine[0]} metadata.');
				}
			} else if (line.startsWith("#")) {
				splitLine = line.split(" ");
				switch (splitLine) {
					case ["#START"]:
					case ["#BPMCHANGE", value]:
						bpm = Std.parseFloat(value);
					case ["#SCROLL", value]:
						scroll = Std.parseFloat(value);
					case ["#DELAY", value]:
						delay = Std.parseFloat(value);
					case ["#MEASURE", value]:
						var sig = value.split("/");
						timeSignature = [for (val in sig) Std.parseInt(val)];
					case ["#GOGOSTART"]:
						gogo = true;
					case ["#GOGOEND"]:
						if (!gogo) {
							throw "GOGO was never started";
						}
						gogo = false;
					case ["#END"]:	
						if (course == null) {
							throw "Course not defined";
						}
						chart.courses.push(course);
					default:
						trace('I am confused, I have never heard of the ${splitLine[0]} command.');
				}
			} else if (Std.parseInt(line.charAt(0)) != null) {
				if (measure  == null) {
					measure = new Measure();
					measure.part = timeSignature[0];
					measure.beat = timeSignature[1];
				}

				for (c in new StringIterator(line)) {
					var char = String.fromCharCode(c);
					if (char == ",") break;
					var note = new Note(Std.parseInt(char));
					note.gogo = gogo;
					note.measureLength = 60000 * (timeSignature[0] / timeSignature[1]) * (timeSignature[0] / bpm) + delay;
					note.scroll = scroll;
					measure.notes.push(note);
				}

				if (line.endsWith(",")) {
					measure.part = timeSignature[0];
					measure.beat = timeSignature[1];
					course.measures.push(measure);
					measure = new Measure();
				}
			}
		}
		return chart;
	}
}
