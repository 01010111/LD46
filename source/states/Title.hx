package states;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxState;

class Title extends FlxState {

    var tiles:Array<TitleTile> = [];
    var can_click:Bool = true;

    override function create() {
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;
        bgColor = 0xFFFFA300;
        var poss = [3,5,4,1,0,2];
        //poss.shuffle();
        for (i in 0...6) {
            var p = poss.pop();
            var pos = get_position(p);
            var tile = new TitleTile(pos.x, pos.y, p, i);
            tiles.push(tile);
            if (i == 5) tile.blank = true;
            add(tile);
            tile.scale.set();
            FlxTween.tween(tile.scale, { x: 1, y: 1 }, 0.2, { ease: FlxEase.backOut, startDelay: i * 0.1 });
        }
    }

    function get_position(p:Int):FlxPoint {
        return FlxPoint.get(p % 3 * 32 + 24, (p / 3).floor() * 32 + 40);
    }

    function get_empty(p:Int) {
        var up = p > 2;
        var down = p < 3;
        var left = p % 3 > 0;
        var right = p % 3 < 2;
        var to_check = [];
        if (up) to_check.push(get_tile(p - 3));
        if (down) to_check.push(get_tile(p + 3));
        if (left) to_check.push(get_tile(p - 1));
        if (right) to_check.push(get_tile(p + 1));
        trace(to_check);
        for (tile in to_check) if (tile.blank) return tile;
        return null;
    }

    function get_tile(p:Int) {
        for (tile in tiles) if (tile.p == p) return tile;
        return null;
    }

    function swap(t1:TitleTile, t2:TitleTile) {
        var p1 = t1.p;
        t1.p = t2.p;
        t2.p = p1;
        var pos1 = get_position(t1.p);
        var pos2 = get_position(t2.p);
        FlxTween.tween(t1, { x: pos1.x, y: pos1.y }, 0.1);
        FlxTween.tween(t2, { x: pos2.x, y: pos2.y }, 0.1);
    }

    function check():Bool {
        var out = true;
        for (tile in tiles) if (tile.animation.frameIndex != tile.p) out = false;
        return out;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (can_click) check_mouse();
    }

    function check_mouse() {
        if (!FlxG.mouse.justPressed) return;
        for (tile in tiles) if (FlxG.mouse.overlaps(tile)) {
            var tile2 = get_empty(tile.p);
            trace(tile2);
            if (tile2 == null) return;
            swap(tile, tile2);
            if (check()) win();
        }
    }

    function win() {
        var i = 0;
        while (tiles.length > 0) {
            var t = tiles.pop();
            FlxTween.tween(t, { x: t.x + 144, angle: 90 }, 0.3, { ease: FlxEase.backIn, startDelay: i++ * 0.1 + 0.25 });
            new FlxTimer().start(1.5, (_) -> FlxG.switchState(new PlayState()));
        }
    }

}

class TitleTile extends FlxSprite {

    public var p:Int;
    public var blank:Bool;

    public function new(x:Float, y:Float, p:Int, i:Int) {
        super(x, y);
        loadGraphic(Images.title__png, true, 32, 32);
        this.p = p;
        animation.frameIndex = i;
    }

}