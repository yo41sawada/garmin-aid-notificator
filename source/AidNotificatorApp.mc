import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class AidNotificatorApp extends Application.AppBase {

    public function initialize() {
        AppBase.initialize();
    }

    public function onStart(state as Dictionary?) as Void {
    }

    public function onStop(state as Dictionary?) as Void {
    }

    public function getInitialView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] {
        return [new AidNotificatorView()];
    }
}
