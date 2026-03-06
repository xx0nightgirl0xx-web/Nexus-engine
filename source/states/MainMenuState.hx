package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class MainMenuState extends FlxState
{
    private var bg:FlxSprite;
    private var titleText:FlxText;
    private var storyButton:FlxButton;
    private var freeplayButton:FlxButton;
    private var modsButton:FlxButton;
    private var optionsButton:FlxButton;

    override public function create():Void
    {
        super.create();

        // Fondo oscuro (cambiar a loadGraphic("assets/main/menuBG.png") cuando agregues asset)
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        add(bg);

        // Título
        titleText = new FlxText(0, 50, 0, "Nexus Engine", 48);
        titleText.screenCenter(X);
        titleText.color = 0xFF00FFFF; // Color neón
        add(titleText);

        // Botones
        storyButton = new FlxButton(0, 200, "Story Mode", onStoryMode);
        storyButton.screenCenter(X);
        storyButton.y -= 100;
        add(storyButton);

        freeplayButton = new FlxButton(0, 300, "Freeplay", onFreeplay);
        freeplayButton.screenCenter(X);
        freeplayButton.y -= 50;
        add(freeplayButton);

        modsButton = new FlxButton(0, 400, "Mods", onMods);
        modsButton.screenCenter(X);
        add(modsButton);

        optionsButton = new FlxButton(0, 500, "Options", onOptions);
        optionsButton.screenCenter(X);
        optionsButton.y += 50;
        add(optionsButton);

        // Animación de entrada de cámara
        FlxG.camera.zoom = 0.8;
        FlxTween.tween(FlxG.camera, {zoom: 1.0}, 1.0, {ease: FlxEase.quadOut});
    }

    private function onStoryMode():Void
    {
        transitionToState(new StoryModeState());
    }

    private function onFreeplay():Void
    {
        transitionToState(new FreeplayState());
    }

    private function onMods():Void
    {
        transitionToState(new ModsState());
    }

    private function onOptions():Void
    {
        transitionToState(new OptionsState());
    }

    private function transitionToState(stateName:String):Void
    {
        // Transición suave: fade out
        FlxTween.tween(FlxG.camera, {alpha: 0}, 0.5, {ease: FlxEase.quadOut, onComplete: function(tween:FlxTween) {
            // Cambiar estado (placeholder, necesitarás implementar los estados)
            switch (stateName) {
                case "StoryModeState":
                    // FlxG.switchState(new StoryModeState());
                    trace("Switch to Story Mode");
                case "FreeplayState":
                    // FlxG.switchState(new FreeplayState());
                    trace("Switch to Freeplay");
                case "ModsState":
                    // FlxG.switchState(new ModsState());
                    trace("Switch to Mods");
                case "OptionsState":
                    // FlxG.switchState(new OptionsState());
                    trace("Switch to Options");
            }
        }});
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}