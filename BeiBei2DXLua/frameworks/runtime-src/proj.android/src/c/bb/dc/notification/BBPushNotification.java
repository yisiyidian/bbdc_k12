package c.bb.dc.notification;

import android.app.Activity;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Intent;

public class BBPushNotification {
	
	private PendingIntent _pendingIntent = null;
	
	public void pushNotification(long ms, Activity act, Class<?> cls) {
		Intent myIntent = new Intent(act, cls);
	    _pendingIntent = PendingIntent.getBroadcast(act, 0, myIntent, 0);
	    
	    AlarmManager alarmManager = cancelNotification(act);
	    alarmManager.set(AlarmManager.RTC, ms, _pendingIntent);
	}
	
	public AlarmManager cancelNotification(Activity act) {
		AlarmManager alarmManager = (AlarmManager)act.getSystemService(android.content.Context.ALARM_SERVICE);
	    alarmManager.cancel(_pendingIntent);
	    return alarmManager;
	}
	
}
