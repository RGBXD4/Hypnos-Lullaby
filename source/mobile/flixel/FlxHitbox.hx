package mobile.flixel;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxDestroyUtil;
import openfl.display.BitmapData;
import openfl.display.Shape;
import mobile.flixel.FlxButton;
import flixel.tweens.FlxTween;

class FlxHitbox extends FlxSpriteGroup
{
    public var buttons:Array<FlxButton> = [];
    
    public function new(mode:Modes)
    {
        super();

        var width = Std.int(FlxG.width / 4);
        var widthS = Std.int(FlxG.width / 5);
        var height = Std.int(FlxG.height * 0.8);
        var colors = [0xFF00FF, 0x00FFFF, 0x00FF00, 0xFF0000, 0xFFFF00]; // 添加第5个颜色

        switch(mode)
        {
            case DEFAULT:
                for (i in 0...4) {
                    buttons[i] = createHint(i * width, 0, width, FlxG.height, colors[i]);
                    add(buttons[i]);
                }

            case SPACE:
                for (i in 0...5) {
                    if (i < 4) {
                        buttons[i] = createHint(i * width, 0, width, height, colors[i]);
                    } else {
                        buttons[i] = createHint(0, height, FlxG.width, FlxG.height - height, colors[i]);
                    }
                    add(buttons[i]);
                }
        }

        scrollFactor.set();
    }

    override function destroy()
    {
        for (i in 0...buttons.length) {
            buttons[i] = FlxDestroyUtil.destroy(buttons[i]);
        }
        buttons = [];
        
        super.destroy();
    }

    function createHintGraphic(width:Int, height:Int, color:Int):BitmapData
    {
        var shape = new Shape();
        shape.graphics.beginFill(color);
        shape.graphics.drawRect(0, 0, width, height);
        shape.graphics.endFill();

        var bitmap = new BitmapData(width, height, true, 0);
        bitmap.draw(shape);
        return bitmap;
    }

    function createHint(x:Float, y:Float, width:Int, height:Int, color:Int):FlxButton
    {
        var hint = new FlxButton(x, y);
        hint.loadGraphic(createHintGraphic(width, height, color));
        hint.solid = false;
        hint.immovable = true;
        hint.scrollFactor.set();
        hint.alpha = 0.00001;

        var hintTween:FlxTween = null;
        hint.onDown.callback = hint.onOver.callback = () -> {
            if (hintTween != null) hintTween.cancel();
            hint.alpha = 0.3;
        };

        hint.onUp.callback = hint.onOut.callback = () -> {
            if (hintTween != null) hintTween.cancel();
            hintTween = FlxTween.tween(hint, {alpha: 0.00001}, 0.2);
        };

        #if FLX_DEBUG
        hint.ignoreDrawDebug = true;
        #end

        return hint;
    }
}

enum Modes
{
    DEFAULT;
    SPACE;
}
