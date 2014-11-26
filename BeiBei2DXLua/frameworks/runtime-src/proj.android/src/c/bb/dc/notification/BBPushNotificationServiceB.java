package c.bb.dc.notification;

import android.content.Intent;

public class BBPushNotificationServiceB extends BBPushNotificationService {
	@Override
	public void onStart(Intent intent, int startId) {
		content = "又在刷朋友圈，还不赶紧来贝贝单词？";
		super.onStart(intent, startId);
	}
}