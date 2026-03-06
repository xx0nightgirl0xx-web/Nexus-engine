package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.ui.FlxBar;
import objects.Character;
import objects.Note;
import haxe.Json;

class PlayState extends FlxState
{
    private var boyfriend:Character;
    private var dad:Character;
    private var notes:FlxTypedGroup<Note>;
    private var strumLine:FlxSprite;
    private var songData:Dynamic;
    private var songPosition:Float = 0;
    private var scrollSpeed:Float = 1.0;
    private var bpm:Float = 100;
    private var crochet:Float;
    private var stepCrochet:Float;
    private var healthBar:FlxBar;
    private var health:Float = 1.0; // 0 to 2, 1 is middle
    private var scoreText:FlxText;
    private var missesText:FlxText;
    private var score:Int = 0;
    private var misses:Int = 0;
    private var songName:String;    private var player1:String = "bf"; // Para compatibilidad Psych
    private var player2:String = "dad";
    private var gfVersion:String = "gf";

    public function new(?song:String = "Tutorial")
    {
        super();
        songName = song;
    }
    public function new(?song:String = "Tutorial")
    {
        super();
        songName = song;
    }

    override public function create():Void
    {
        super.create();

        // Inicializar save
        if (FlxG.save.data.score == null) FlxG.save.data.score = 0;
        if (FlxG.save.data.highscore == null) FlxG.save.data.highscore = {};

        // Cargar opciones
        if (FlxG.save.data.downscroll != null) scrollSpeed = FlxG.save.data.downscroll ? -1.0 : 1.0; // Placeholder para downscroll
        if (FlxG.save.data.ghostTapping != null) {} // Implementar ghost tapping

        // Cargar datos de canción
        var jsonString = sys.io.File.getContent("assets/charts/" + songName.toLowerCase() + ".json");
        songData = Json.parse(jsonString).song;
        bpm = songData.bpm;
        crochet = (60 / bpm) * 1000;
        stepCrochet = crochet / 4;

        // Compatibilidad Psych/V-Slice
        if (Reflect.hasField(songData, "player1")) player1 = songData.player1;
        if (Reflect.hasField(songData, "player2")) player2 = songData.player2;
        if (Reflect.hasField(songData, "gfVersion")) gfVersion = songData.gfVersion;

        // Fondo (cambiar a loadGraphic("assets/play/stageBG.png"))
        var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        add(bg);

        // Strumline
        strumLine = new FlxSprite(100, 400).makeGraphic(400, 10, 0xFFFFFFFF);
        add(strumLine);

        // Personajes
        dad = new Character(200, 200, player2);
        add(dad);

        boyfriend = new Character(600, 200, player1);
        add(boyfriend);

        // Health Bar
        healthBar = new FlxBar(50, 50, LEFT_TO_RIGHT, 400, 20, null, "health", 0, 2);
        healthBar.createFilledBar(0xFFFF0000, 0xFF00FF00); // Rojo a verde
        add(healthBar);

        // UI Texts
        scoreText = new FlxText(50, 80, 0, "Score: 0", 24);
        scoreText.color = 0xFFFFFFFF;
        add(scoreText);

        missesText = new FlxText(50, 110, 0, "Misses: 0", 24);
        missesText.color = 0xFFFFFFFF;
        add(missesText);

        // Notas
        notes = new FlxTypedGroup<Note>();
        add(notes);

        // Generar notas desde chart
        for (section in songData.notes)
        {
            for (noteData in section.sectionNotes)
            {
                var note = new Note(noteData[0], noteData[1]);
                notes.add(note);
            }
        }

        // Música (placeholder, necesitas asset)
        // FlxG.sound.playMusic("assets/music/tutorial.ogg");
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        songPosition += elapsed * 1000;

        // Actualizar notas
        notes.forEachAlive(function(note:Note) {
            note.updateNote(elapsed, scrollSpeed);
            if (note.y > FlxG.height + 100 && !note.wasGoodHit)
            {
                note.kill();
                misses++;
                health -= 0.2;
                if (health < 0) health = 0;
                updateUI();
            }
        });

        // Input
        if (FlxG.keys.justPressed.LEFT)
            checkNoteHit(0);
        if (FlxG.keys.justPressed.DOWN)
            checkNoteHit(1);
        if (FlxG.keys.justPressed.UP)
            checkNoteHit(2);
        if (FlxG.keys.justPressed.RIGHT)
            checkNoteHit(3);
        if (FlxG.keys.justPressed.A)
            checkNoteHit(4);
        if (FlxG.keys.justPressed.S)
            checkNoteHit(5);
        if (FlxG.keys.justPressed.W)
            checkNoteHit(6);
        if (FlxG.keys.justPressed.D)
            checkNoteHit(7);
        if (FlxG.keys.justPressed.SPACE)
            checkNoteHit(8);

        if (FlxG.keys.justPressed.ESCAPE)
        {
            saveScore();
            FlxG.switchState(new FreeplayState());
        }
    }

    private function checkNoteHit(direction:Int):Void
    {
        var hit:Bool = false;
        notes.forEachAlive(function(note:Note) {
            if (note.noteData == direction && Math.abs(note.strumTime - songPosition) < 150 && !note.wasGoodHit)
            {
                note.wasGoodHit = true;
                note.kill();
                boyfriend.playAnim(["singLEFT", "singDOWN", "singUP", "singRIGHT", "singLEFT", "singDOWN", "singUP", "singRIGHT", "singUP"][direction]); // Placeholder para diagonales
                score += 100;
                health += 0.1;
                if (health > 2) health = 2;
                hit = true;
            }
        });
        if (!hit)
        {
            misses++;
            health -= 0.2;
            if (health < 0) health = 0;
        }
        updateUI();
    }

    private function saveScore():Void
    {
        if (FlxG.save.data.highscore[songName] == null || score > FlxG.save.data.highscore[songName])
        {
            FlxG.save.data.highscore[songName] = score;
        }
        FlxG.save.flush();
    }

    private function updateUI():Void
    {
        healthBar.value = health;
        scoreText.text = "Score: " + score;
        missesText.text = "Misses: " + misses;
    }
}