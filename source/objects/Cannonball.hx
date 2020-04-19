package objects;

import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.ParticleEmitter.Particle;

class Cannonball extends Particle {
	
	public function new() {
		super();
		loadGraphic(Images.cannonball__png, true, 8, 8);
		this.make_and_center_hitbox(4, 4);
		animation.add('play', [0,1,2,3], 24);
		PLAYSTATE.hazards.add(this);
		PLAYSTATE.projectiles.add(this);
	}

	override function fire(options:FireOptions) {
		super.fire({
			position: options.position.copyTo().add(-2, -2),
			velocity: options.velocity
		});
		PLAYSTATE.puffs.fire({ position: options.position });
		animation.play('play');
	}

	override function kill() {
		PLAYSTATE.explosions.fire({ position: getMidpoint() });
		super.kill();
	}

	override function update(dt:Float) {
		super.update(dt);
		if (x < 0 || x > 140 || y < 0 || y > 140) kill();
	}

}