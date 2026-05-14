import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class AidNotificatorView extends WatchUi.DataField {

    private const INTERVAL_KM as Float = 5.0;

    private var _distanceKm as Float = 0.0;

    public function initialize() {
        DataField.initialize();
    }

    public function compute(info as Activity.Info) as Void {
        if (info.elapsedDistance != null) {
            _distanceKm = (info.elapsedDistance as Float) / 1000.0;
        }
    }

    public function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

        var nextAidKm = Math.ceil(_distanceKm / INTERVAL_KM) * INTERVAL_KM;
        if (nextAidKm < INTERVAL_KM) {
            nextAidKm = INTERVAL_KM;
        }
        var remainingKm = nextAidKm - _distanceKm;

        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_LARGE,
            remainingKm.format("%.1f") + "km",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}
