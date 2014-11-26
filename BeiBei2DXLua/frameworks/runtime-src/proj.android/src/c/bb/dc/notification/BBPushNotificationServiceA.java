package c.bb.dc.notification;

import android.content.Intent;

public class BBPushNotificationServiceA extends BBPushNotificationService {
	@Override
	public void onStart(Intent intent, int startId) {
		content = "救命啊！有怪兽！";
		super.onStart(intent, startId);
	}
}