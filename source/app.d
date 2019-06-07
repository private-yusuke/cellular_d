import cellular.cellular;
import cellular.palette;
import std.stdio;
import std.conv;
import std.algorithm;
import std.string;
import derelict.sdl2.sdl;

int main(string[] args) {
	if(args.length < 2) {
		stderr.writeln("Usage: ./cellular_d <rule> <width> <height> <startFrom>");
		return 1;
	}
	ulong rule = args[1].to!ulong;

	int width = 200, height = 200;
	if(args.length >= 3) {
		width = args[2].to!int;
		height = args[3].to!int;
	}
	int startX = width / 2;
	if(args.length >= 5) {
		switch(args[4]) {
			case "left": startX = 0; break;
			case "right": startX = width-1; break;
			default: break;
		}
	}

	auto app = new App(width, height);
	auto cellular = new Cellular(width, height, rule);
	cellular.setCell(0, startX, true);
	SDL_Point[] pointarr;

	// auto font = app.addFont("/Library/Fonts/Arial.ttf", 20, "Arial");

	void update() {
		if(!cellular.renderNext) return;
		with(app.palette) {
			background(255, 255, 255);
			color(0, 0, 0);
			// drawString(format("Rule %d", cellular.rule), app.getFont(font), 0, 0);
			foreach(i, v; cellular.cellular[cellular.doneHeight]) {
				if(v) pointarr ~= SDL_Point(i.to!int, cellular.doneHeight.to!int);
			}
			points(pointarr);
		}
	}

	void fq(SDL_Event e) {
		if(e.key.keysym.sym == SDLK_q) app.running = false;
		if(e.key.keysym.sym == SDLK_s) app.palette.exportCanvas("test.bmp");
	}

	app.onUpdate = &update;
	app.addEvent(Event(SDL_KEYDOWN, &fq), "press_q");
	app.palette.background(255, 255, 255);
	return app.exec();
}
