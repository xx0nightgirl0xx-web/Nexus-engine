package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class StoryModeState extends FlxState
{
    private var bg:FlxSprite;
    private var titleText:FlxText;
    private var weekButtons:Array<FlxButton> = [];
    private var backButton:FlxButton;
    private var weeks:Array<{name:String, songs:Array<String>}> = [
        {name: "Tutorial", songs: ["Tutorial"]},
        {name: "Week 1", songs: ["Bopeebo", "Fresh", "Dadbattle"]}
    ];

    override public function create():Void
    {
        super.create();

        // Fondo oscuro (cambiar a loadGraphic("assets/story/storyBG.png"))
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        add(bg);

        // Título
        titleText = new FlxText(0, 50, 0, "Story Mode", 48);
        titleText.screenCenter(X);
        titleText.color = 0xFF00FFFF;
        add(titleText);

        // Botones de semanas
        for (i in 0...weeks.length)
        {
            var button = new FlxButton(0, 150 + i * 100, weeks[i].name, function() { selectWeek(i); });
            button.screenCenter(X);
            weekButtons.push(button);
            add(button);
        }

        backButton = new FlxButton(50, FlxG.height - 100, "Back", onBack);
        add(backButton);

        // Animación
        FlxG.camera.zoom = 0.8;
        FlxTween.tween(FlxG.camera, {zoom: 1.0}, 1.0, {ease: FlxEase.quadOut});
    }

    private function selectWeek(weekIndex:Int):Void
    {
        // Por ahora, jugar la primera canción de la semana
        var song = weeks[weekIndex].songs[0];
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