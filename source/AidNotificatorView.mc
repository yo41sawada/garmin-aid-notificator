import Toybox.Activity;
import Toybox.Attention;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class AidNotificatorView extends WatchUi.DataField {

    // 通知する距離リスト（km）
    private const AID_STATIONS as Array<Float> = [5.0, 10.0, 15.0, 20.0, 25.0, 30.0, 35.0, 40.0] as Array<Float>;

    private var _nextAidIndex as Number = 0;
    private var _remainingKm as Float = 0.0;
    private var _isActive as Boolean = false;

    public function initialize() {
        DataField.initialize();
        _remainingKm = AID_STATIONS[0];
    }

    public function compute(info as Activity.Info) as Void {
        if (info.elapsedDistance == null) {
            return;
        }

        _isActive = true;
        var distanceKm = (info.elapsedDistance as Float) / 1000.0;

        if (_nextAidIndex >= AID_STATIONS.size()) {
            _remainingKm = 0.0;
            return;
        }

        if (distanceKm >= AID_STATIONS[_nextAidIndex]) {
            _notify();
            _nextAidIndex++;
        }

        if (_nextAidIndex < AID_STATIONS.size()) {
            _remainingKm = AID_STATIONS[_nextAidIndex] - distanceKm;
        } else {
            _remainingKm = 0.0;
        }
    }

    private function _notify() as Void {
        var settings = System.getDeviceSettings();
        if ((Attention has :playTone) && settings.tonesOn) {
            Attention.playTone(Attention.TONE_DISTANCE_ALERT);
        }
        if ((Attention has :vibrate) && settings.vibrateOn) {
            var vibeData = [new Attention.VibeProfile(100, 1000)] as Array<Attention.VibeProfile>;
            Attention.vibrate(vibeData);
        }
        try {
            showAlert(new AidAlertView());
        } catch (ex instanceof Lang.Exception) {
            // DataFieldAlert が利用できない状況では無視する
        }
    }

    public function onUpdate(dc as Graphics.Dc) as Void {
        var backgroundColor = getBackgroundColor();
        var textColor = (backgroundColor == Graphics.COLOR_BLACK) ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;
        dc.setColor(textColor, backgroundColor);
        dc.clear();

        var cx = dc.getWidth() / 2;
        var cy = dc.getHeight() / 2;

        if (!_isActive) {
            dc.drawText(cx, cy, Graphics.FONT_LARGE, "AID Ready", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        } else if (_nextAidIndex >= AID_STATIONS.size()) {
            dc.drawText(cx, cy, Graphics.FONT_LARGE, "Keep going!", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        } else {
            var labelHeight = dc.getFontHeight(Graphics.FONT_TINY);
            var numberHeight = dc.getFontHeight(Graphics.FONT_NUMBER_HOT);
            var gap = 4;
            var totalHeight = labelHeight + gap + numberHeight;
            var startY = (dc.getHeight() - totalHeight) / 2;
            dc.drawText(cx, startY + labelHeight / 2, Graphics.FONT_TINY, "NEXT is", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(cx, startY + labelHeight + gap + numberHeight / 2, Graphics.FONT_NUMBER_HOT, _remainingKm.format("%.2f"), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }
}
