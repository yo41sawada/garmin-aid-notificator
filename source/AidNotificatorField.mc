import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Activity;
import Toybox.Lang;

class AidNotificatorField extends WatchUi.DataField {

    function initialize() {
        DataField.initialize();
    }

    function onLayout(dc as Graphics.Dc) as Void {
    }

    function compute(info as Activity.Info) as Lang.Numeric or Lang.Duration or Lang.String or Null {
        return null;
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

        dc.drawText(
            width / 2,
            height / 2,
            Graphics.FONT_MEDIUM,
            "Hello World",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}
