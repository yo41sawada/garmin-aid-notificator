import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class AidNotificatorView extends WatchUi.DataField {

    private const INTERVAL_KM as Float = 5.0;

    private var _remainingKm as Float = INTERVAL_KM;

    public function initialize() {
        DataField.initialize();
    }

    public function compute(info as Activity.Info) as Void {
        if (info.elapsedDistance != null) {
            var distanceKm = (info.elapsedDistance as Float) / 1000.0;
            var nextAidKm = Math.ceil(distanceKm / INTERVAL_KM) * INTERVAL_KM;
            if (nextAidKm < INTERVAL_KM) {
                nextAidKm = INTERVAL_KM;
            }
            _remainingKm = nextAidKm - distanceKm;
        }
    }

    public function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_LARGE,
            _remainingKm.format("%.1f") + "km",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}
