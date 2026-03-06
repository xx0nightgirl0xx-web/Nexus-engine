package objects;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;

class Note extends FlxSprite
{
    public var strumTime:Float;
    public var noteData:Int; // 0-8: direcciones (Psych compatible)

    public function new(strumTime:Float, noteData:Int)
    {
        super();
        this.strumTime = strumTime;
        this.noteData = noteData;

        // Placeholder: Sprite de nota (necesitas assets)
        loadGraphic("assets/images/notes.png", true, 50, 50); // Ajusta
        animation.add("note", [noteData], 0, false);
        animation.play("note");

        // Posiciones para 9 notas (Psych style)
        var positions = [
            {x: 100, y: 0},   // LEFT
            {x: 200, y: 0},   // DOWN
            {x: 300, y: 0},   // UP
            {x: 400, y: 0},   // RIGHT
            {x: 50, y: -50},  // LEFT-UP
            {x: 150, y: -50}, // DOWN-UP
            {x: 250, y: -50}, // UP-UP
            {x: 350, y: -50}, // RIGHT-UP
            {x: 250, y: 50}   // SPACE
        ];
        if (noteData < positions.length) {
            x = positions[noteData].x;
            y = positions[noteData].y - 100; // Arriba
        }
    }

    public function updateNote(elapsed:Float, scrollSpeed:Float):Void
    {
        y += scrollSpeed * elapsed * 100; // Caída
    }
}