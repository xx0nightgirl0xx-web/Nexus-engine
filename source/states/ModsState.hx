package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import polymod.Polymod;

class ModsState extends FlxState
{
    private var bg:FlxSprite;
    private var titleText:FlxText;
    private var modButtons:Array<FlxButton> = [];
    private var backButton:FlxButton;
    private var mods:Array<String> = []; // Lista de mods detectados

    override public function create():Void
    {
        super.create();

        // Inicializar Polymod
        Polymod.init({
            modRoot: "mods/",
            dirs: [], // Se llenará con carpetas
            framework: OPENFL
        });

        // Detectar mods
        var modDirs = sys.FileSystem.readDirectory("mods");
        for (dir in modDirs)
        {
            if (sys.FileSystem.isDirectory("mods/" + dir))
            {
                mods.push(dir);
            }
        }

        // Fondo oscuro (cambiar a loadGraphic("assets/mods/modsBG.png"))
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        add(bg);

        // Título
        titleText = new FlxText(0, 50, 0, "Mod Hub", 48);
        titleText.screenCenter(X);
        titleText.color = 0xFF00FFFF;
        add(titleText);

        // Botones de mods
        for (i in 0...mods.length)
        {
            var button = new FlxButton(0, 150 + i * 100, mods[i], function() { selectMod(mods[i]); });
            button.screenCenter(X);
            modButtons.push(button);
            add(button);
        }

        backButton = new FlxButton(50, FlxG.height - 100, "Back", onBack);
        add(backButton);

        // Animación
        FlxG.camera.zoom = 0.8;
        FlxTween.tween(FlxG.camera, {zoom: 1.0}, 1.0, {ease: FlxEase.quadOut});
    }

    private function selectMod(mod:String):Void
    {
        // Cargar mod con Polymod
        Polymod.loadMod(mod);
        // Transitar a Freeplay o algo
        FlxTween.tween(FlxG.camera, {alpha: 0}, 0.5, {ease: FlxEase.quadOut, onComplete: function(tween:FlxTween) {
            FlxG.switchState(new FreeplayState());
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