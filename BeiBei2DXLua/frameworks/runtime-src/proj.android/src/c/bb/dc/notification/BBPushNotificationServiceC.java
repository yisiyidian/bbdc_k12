package c.bb.dc.notification;

import android.content.Intent;

public class BBPushNotificationServiceC extends BBPushNotificationService {
	@Override
	public void onStart(Intent intent, int startId) {
		content = "没时间解释了！快点来帮帮我！";
		super.onStart(intent, startId);
	}
}