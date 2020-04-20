package objects;

import flixel.FlxObject;
import flixel.FlxSprite;

class Block extends FlxSprite {

	var direction:Direction;

	public function new(x:Float, y:Float, d:String) {
		super(x, y, Images.block__png);
		direction = switch d {
			case 'UP': UP;
			case 'DOWN': DOWN;
			case 'LEFT': LEFT;
			case 'RIGHT': RIGHT;
			default: RIGHT;
		};
		PLAYSTATE.hazards.add(this);
		PLAYSTATE.collidables.add(this);
		PLAYSTATE.fleshies.add(this);
	}

	override function update(elapsed:Float) {
		var old_direction = direction;
		if (justTouched(FlxObject.ANY)) FlxG.sound.play(Audio.block_hit__mp3);
		if (wasTouching & FlxObject.CEILING > 0) direction = DOWN;
		if (wasTouching & FlxObject.RIGHT > 0) direction = LEFT;
		if (wasTouching & FlxObject.FLOOR > 0) direction = UP;
		if (wasTouching & FlxObject.LEFT > 0) direction = RIGHT;
		if (y <= 0) {
			y = 0;
			direction = DOWN;
		}
		if (x + width >= 144) {
			x = 144 - width;
			direction = LEFT;
		}
		if (y + height >= 144) {
			y = 144 - height;
			direction = UP;
		}
		if (x <= 0) {
			x = 0;
			direction = RIGHT;
		}
		super.update(elapsed);
		if (old_direction != direction || velocity.vector_length() == 0) switch direction {
			case UP: velocity.set(0, -20);
			case DOWN: velocity.set(0, 20);
			case LEFT: velocity.set(-20, 0);
			case RIGHT: velocity.set(20, 0);
		}
	}
	
}

enum Direction {
	UP;
	DOWN;
	LEFT;
	RIGHT;
}