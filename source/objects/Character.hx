package objects;

import flixel.FlxSprite;
import flixel.animation.FlxAnimation;

class Character extends FlxSprite
{
    public var name:String;

    public function new(x:Float, y:Float, characterName:String)
    {
        super(x, y);
        this.name = characterName;

        // Placeholder: Cargar sprite básico (necesitas assets reales)
        loadGraphic("assets/images/characters/" + characterName + ".png", true, 100, 100); // Ajusta tamaño

        // Animaciones básicas
        animation.add("idle", [0, 1, 2, 3], 24, true);
        animation.add("singLEFT", [4, 5], 24, false);
        animation.add("singDOWN", [6, 7], 24, false);
        animation.add("singUP", [8, 9], 24, false);
        animation.add("singRIGHT", [10, 11], 24, false);

        animation.play("idle");
    }

    public function playAnim(anim:String):Void
    {
        animation.play(anim);
    }
}