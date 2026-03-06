package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class OptionsState extends FlxState
{
    private var bg:FlxSprite;
    private var titleText:FlxText;
    private var downscrollButton:FlxButton;
    private var ghostTappingButton:FlxButton;
    private var backButton:FlxButton;
    private var downscroll:Bool = false;
    private var ghostTapping:Bool = true;

    override public function create():Void
    {
        super.create();

        // Fondo oscuro (cambiar a loadGraphic("assets/options/optionsBG.png"))
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        add(bg);

        // Título
        titleText = new FlxText(0, 50, 0, "Options", 48);
        titleText.screenCenter(X);
        titleText.color = 0xFF00FFFF;
        add(titleText);

        // Opciones
        downscrollButton = new FlxButton(0, 200, "Downscroll: " + (downscroll ? "ON" : "OFF"), toggleDownscroll);
        downscrollButton.screenCenter(X);
        add(downscrollButton);

        ghostTappingButton = new FlxButton(0, 300, "Ghost Tapping: " + (ghostTapping ? "ON" : "OFF"), toggleGhostTapping);
        ghostTappingButton.screenCenter(X);
        add(ghostTappingButton);

        // Más opciones aquí (controles, FPS, etc.)

        backButton = new FlxButton(50, FlxG.height - 100, "Back", onBack);
        add(backButton);

        // Animación
        FlxG.camera.zoom = 0.8;
        FlxTween.tween(FlxG.camera, {zoom: 1.0}, 1.0, {ease: FlxEase.quadOut});
    }

    private function toggleDownscroll():Void
    {
        downscroll = !downscroll;
        downscrollButton.text = "Downscroll: " + (downscroll ? "ON" : "OFF");
        // Guardar en FlxSave
        FlxG.save.data.downscroll = downscroll;
        FlxG.save.flush();
    }

    private function toggleGhostTapping():Void
    {
        ghostTapping = !ghostTapping;
        ghostTappingButton.text = "Ghost Tapping: " + (ghostTapping ? "ON" : "OFF");
        FlxG.save.data.ghostTapping = ghostTapping;
        FlxG.save.flush();
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