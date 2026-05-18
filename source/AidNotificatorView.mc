import Toybox.Activity;
import Toybox.Application;
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

    private function _drawProgressArc(dc as Graphics.Dc, textColor as Number) as Void {
        var n = AID_STATIONS.size();
        var gap = 4.0;
        var segArc = (360.0 - n * gap) / n;
        var cx = dc.getWidth() / 2;
        var cy = dc.getHeight() / 2;
        var size = dc.getWidth() < dc.getHeight() ? dc.getWidth() : dc.getHeight();
        var r = size / 2 - 15;
        var dimColor = (textColor == Graphics.COLOR_WHITE) ? Graphics.COLOR_DK_GRAY : Graphics.COLOR_LT_GRAY;

        dc.setPenWidth(20);
        for (var i = 0; i < n; i++) {
            var startDeg = 90.0 - i * (segArc + gap);
            if (startDeg < 0.0) { startDeg += 360.0; }
            var endDeg = startDeg - segArc;
            if (endDeg < 0.0) { endDeg += 360.0; }
            dc.setColor(i < _nextAidIndex ? dimColor : textColor, Graphics.COLOR_TRANSPARENT);
            dc.drawArc(cx, cy, r, Graphics.ARC_CLOCKWISE, startDeg.toNumber(), endDeg.toNumber());
        }
        dc.setPenWidth(1);
    }

    public function onUpdate(dc as Graphics.Dc) as Void {
        var backgroundColor = getBackgroundColor();
        var textColor = (backgroundColor == Graphics.COLOR_BLACK) ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;
        dc.setColor(textColor, backgroundColor);
        dc.clear();
        _drawProgressArc(dc, textColor);
        dc.setColor(textColor, backgroundColor);

        var text;
        if (!_isActive) {
            var cx = dc.getWidth() / 2;
            var cy = dc.getHeight() / 2;
            var icon = Application.loadResource(Rez.Drawables.ReadyIcon) as Graphics.BitmapReference;
            var aidTextRes = (backgroundColor == Graphics.COLOR_BLACK) ? Rez.Drawables.AidTextWhite : Rez.Drawables.AidTextBlack;
            var aidText = Application.loadResource(aidTextRes) as Graphics.BitmapReference;
            dc.drawBitmap(cx - 80, cy - 108, aidText);
            dc.drawBitmap(cx - 50, cy - 50, icon);
            dc.drawText(cx, cy + 78, Graphics.FONT_TINY, "notificator", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            return;
        } else if (_nextAidIndex >= AID_STATIONS.size()) {
            text = "Keep going!";
        } else {
            var cx = dc.getWidth() / 2;
            var labelHeight = dc.getFontHeight(Graphics.FONT_TINY);
            var numberHeight = dc.getFontHeight(Graphics.FONT_NUMBER_HOT);
            var gap = 4;
            var totalHeight = labelHeight + gap + numberHeight;
            var startY = (dc.getHeight() - totalHeight) / 2;
            dc.drawText(cx, startY + labelHeight / 2, Graphics.FONT_TINY, "NEXT is", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(cx, startY + labelHeight + gap + numberHeight / 2, Graphics.FONT_NUMBER_HOT, _remainingKm.format("%.2f"), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            return;
        }
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_LARGE,
            text,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}
