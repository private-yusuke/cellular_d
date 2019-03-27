module cellular.cellular;

class Cellular {
	ulong width, height;
	bool[][] cellular;
	ulong doneHeight;
	ulong rule;

	this(ulong width, ulong height, ulong rule) {
		this.width = width;
		this.height = height;
		this.rule = rule;
		cellular = new bool[][](height, width);
	}

	bool isNext(bool[] state) {
		ulong tmp;
		if(state[0]) tmp += 4;
		if(state[1]) tmp += 2;
		if(state[2]) tmp += 1;

		return (this.rule & (1 << tmp)) != 0;
	}
	bool setCell(ulong y, ulong x, bool state) {
		if(y >= this.height || x >= this.width) return false;
		this.cellular[y][x] = state;
		return true;
	}

	bool renderNext() {
		if(doneHeight == this.height - 1) return false;
		
		foreach(i; 0..this.width) {
			bool f1 = this.cellular[doneHeight][(i-1+width)%width];
			bool f2 = this.cellular[doneHeight][i];
			bool f3 = this.cellular[doneHeight][(i+1)%width];
			if(isNext([f1, f2, f3])) this.cellular[doneHeight+1][i] = true;
		}

		doneHeight++;
		return true;
	}
}