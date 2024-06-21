package tja;

@:structInit
class Chart {
	public var header: ChartHeader;
	public var courses: Array<Course> = [];
	
	public function new() {
		this.header = new ChartHeader();
	}
}
