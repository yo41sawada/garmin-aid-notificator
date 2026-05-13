import Toybox.Activity;
import Toybox.Graphics;
import Toybox.WatchUi;

class AidNotificatorView extends WatchUi.DataField {

    public function initialize() {
        DataField.initialize();
    }

    public function compute(info as Activity.Info) as Void {
    }

    public function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_MEDIUM,
            "Hello World",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}
