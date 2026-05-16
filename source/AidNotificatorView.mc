import Toybox.Activity;
import Toybox.Attention;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class AidNotificatorView extends WatchUi.DataField {

    private const INTERVAL_KM as Float = 5.0;

    private var _remainingKm as Float = INTERVAL_KM;
    private var _lastNotifiedAidKm as Float = 0.0;

    public function initialize() {
        DataField.initialize();
    }

    public function compute(info as Activity.Info) as Void {
        if (info.elapsedDistance == null) {
            return;
        }

        var distanceKm = (info.elapsedDistance as Float) / 1000.0;

        var nextNotifyKm = _lastNotifiedAidKm + INTERVAL_KM;
        if (distanceKm >= nextNotifyKm) {
            _notify();
            _lastNotifiedAidKm = nextNotifyKm;
        }

        var nextAidKm = _lastNotifiedAidKm + INTERVAL_KM;
        _remainingKm = nextAidKm - distanceKm;
    }

    private function _notify() as Void {
        if (Attention has :playTone) {
            Attention.playTone(Attention.TONE_ALERT_HI);
        }
        if (Attention has :vibrate) {
            var vibeData = [new Attention.VibeProfile(100, 1000)] as Array<Attention.VibeProfile>;
            Attention.vibrate(vibeData);
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
