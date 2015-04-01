package c.bb.dc.notification;

import java.util.Iterator;

import org.json.JSONException;
import org.json.JSONObject;

import com.avos.avoscloud.AVOSCloud;
import com.beibei.wordmaster.App;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

/*
      {
        "channels":[ "public"],
        "data": {
          "action": "com.beibei.wordmaster.push",
          "name": "push",
          "content": "~~~~~~~"
        }
      }
      
 */
public class AvosReceiver extends BroadcastReceiver {

	private static final String TAG = "AvosReceiver";

    @Override
    public void onReceive(Context context, Intent intent) {
//        Log.d(TAG, "Get Broadcat");
//        try {
//            String action = intent.getAction();
//            String channel = intent.getExtras().getString("com.avos.avoscloud.Channel");
//            //获取消息内容
//            JSONObject json = new JSONObject(intent.getExtras().getString("com.avos.avoscloud.Data"));
//
//            Log.d(TAG, "got action " + action + " on channel " + channel + " with:");
//            Iterator<?> itr = json.keys();
//            while (itr.hasNext()) {
//                String key = (String) itr.next();
//                Log.d(TAG, "..." + key + " => " + json.getString(key));
//            }
//        } catch (JSONException e) {
//            Log.d(TAG, "JSONException: " + e.getMessage());
//        }
    	
//    	try {
//    		if (intent.getAction().equals("com.beibei.wordmaster.push")) {
//    	        JSONObject json = new JSONObject(intent.getExtras().getString("com.avos.avoscloud.Data"));
//    	        final String message = json.getString("content");
//    	        Intent resultIntent = new Intent(AVOSCloud.applicationContext, App.class);
//    	        PendingIntent pendingIntent = PendingIntent.getActivity(AVOSCloud.applicationContext, 0, resultIntent, PendingIntent.FLAG_UPDATE_CURRENT);
//    	        NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(AVOSCloud.applicationContext)
//    	                .setContentTitle("贝贝单词")
//    	                .setContentText(message)
//    	                .setTicker(message);
//    	        mBuilder.setContentIntent(pendingIntent);
//    	        mBuilder.setAutoCancel(true);
//
//    	        int mNotificationId = 10086;
//    	        NotificationManager mNotifyMgr = (NotificationManager) AVOSCloud.applicationContext.getSystemService(Context.NOTIFICATION_SERVICE);
//    	        mNotifyMgr.notify(mNotificationId, mBuilder.build());
//    	      }
//    	    } catch (Exception e) {
//    	    	Log.d(TAG, "Exception: " + e.getMessage());
//    	    }
    }

}
