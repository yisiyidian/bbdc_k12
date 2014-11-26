package c.bb.dc.notification;

import android.content.Intent;

public class BBPushNotificationServiceD extends BBPushNotificationService {
	@Override
	public void onStart(Intent intent, int startId) {
		content = "好久不见啦，贝贝想你啦！";
		super.onStart(intent, startId);
	}
}