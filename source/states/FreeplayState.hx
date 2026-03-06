package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class FreeplayState extends FlxState
{
    private var bg:FlxSprite;
    private var titleText:FlxText;
    private var songButtons:Array<FlxButton> = [];
    private var songs:Array<String> = ["Tutorial", "Bopeebo", "Fresh", "Dadbattle"]; // Placeholder para Week 1

    override public function create():Void
    {
        super.create();

        // Fondo oscuro (cambiar a loadGraphic("assets/freeplay/freeplayBG.png"))
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        add(bg);

        // Título
        titleText = new FlxText(0, 50, 0, "Freeplay", 48);
        titleText.screenCenter(X);
        titleText.color = 0xFF00FFFF;
        add(titleText);

        // Botones de canciones
        for (i in 0...songs.length)
        {
            var button = new FlxButton(0, 150 + i * 100, songs[i], function() { selectSong(songs[i]); });
            button.screenCenter(X);
            songButtons.push(button);
            add(button);
        }

        // Botón de vuelta
        var backButton = new FlxButton(50, FlxG.height - 100, "Back", onBack);
        add(backButton);

        // Animación de entrada
        FlxG.camera.zoom = 0.8;
        FlxTween.tween(FlxG.camera, {zoom: 1.0}, 1.0, {ease: FlxEase.quadOut});
    }

    private function selectSong(song:String):Void
    {
        // Transición a PlayState con la canción seleccionada
        FlxTween.tween(FlxG.camera, {alpha: 0}, 0.5, {ease: FlxEase.quadOut, onComplete: function(tween:FlxTween) {
            FlxG.switchState(new PlayState(song));
        }});
    }

    private function onBack():Void
    {
        FlxG.switchState(new MainMenuState());
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}