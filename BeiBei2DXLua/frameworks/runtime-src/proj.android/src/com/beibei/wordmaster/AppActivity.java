/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2011      Zynga Inc.
Copyright (c) 2013-2014 Chukong Technologies Inc.
 
http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package com.beibei.wordmaster;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.cocos2dx.lib.Cocos2dxActivity;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.os.Environment;
import android.provider.Settings;
import android.view.WindowManager;
import android.widget.Toast;

import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVFile;
import com.avos.avoscloud.AVOSCloud;
import com.avos.avoscloud.AVAnalytics;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.AVQuery;
import com.avos.avoscloud.AVUser;
import com.avos.avoscloud.GetFileCallback;
import com.avos.avoscloud.GetDataCallback;
import com.avos.avoscloud.FindCallback;
import com.avos.avoscloud.ProgressCallback;
import com.avos.avoscloud.SignUpCallback;
import com.avos.avoscloud.LogInCallback;
import com.alibaba.fastjson.JSONObject;
import com.anysdk.framework.PluginWrapper;

// The name of .so is specified in AndroidMenifest.xml. NativityActivity will load it automatically for you.
// You can use "System.loadLibrary()" to load other .so files.

public class AppActivity extends Cocos2dxActivity {

	static String hostIPAdress="0.0.0.0";
	private static Context context = null;
	private static AppActivity instance = null;
	
	private static String LEAN_CLOUD_ID_TEST  =  "gqzttdmaxmb451s2ypjkkdj91a0m9izsk069hu4wji3tuepn";
	private static String LEAN_CLOUD_KEY_TEST =  "x6uls40kqxb3by8uig1b42v9m6erd2xd6xqtw1z3lpg4znb3";

	private static String LEAN_CLOUD_ID       =  "94uw2vbd553rx8fa6h5kt2y1w07p0x2ekwusf4w88epybnrp";
	private static String LEAN_CLOUD_KEY      =  "lqsgx6mtmj65sjgrekfn7e5c28xc7koptbk9mqag2oraagdz";
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		if (nativeIsDebug()) {
			// test server
			AVOSCloud.initialize(this, LEAN_CLOUD_ID_TEST, LEAN_CLOUD_KEY_TEST);
			AVOSCloud.setDebugLogEnabled(true);
		} else {
			// app store server
			AVOSCloud.initialize(this, LEAN_CLOUD_ID, LEAN_CLOUD_KEY);
		}
		
		AVAnalytics.trackAppOpened(getIntent());
		AVAnalytics.enableCrashReport(this, true);
		
		context = getApplicationContext();
		instance = this;
		
		PluginWrapper.init(this);
		
		if(nativeIsLandScape()) {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
		} else {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT);
		}
		
		//2.Set the format of window
		
		// Check the wifi is opened when the native is debug.
		if (nativeIsDebug())
		{
			getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
			if (!isNetworkConnected())
			{
				AlertDialog.Builder builder=new AlertDialog.Builder(this);
				builder.setTitle("Warning");
				builder.setMessage("Open Wifi for debuging...");
				builder.setPositiveButton("OK",new DialogInterface.OnClickListener() {
					
					@Override
					public void onClick(DialogInterface dialog, int which) {
						startActivity(new Intent(Settings.ACTION_WIFI_SETTINGS));
						finish();
						System.exit(0);
					}
				});
				builder.setCancelable(false);
				builder.show();
			}
		}
		hostIPAdress = getHostIpAddress();
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data){
		super.onActivityResult(requestCode, resultCode, data);
		PluginWrapper.onActivityResult(requestCode, resultCode, data);
	}
	
	@Override
	protected void onPause() {
		PluginWrapper.onPause();
		AVAnalytics.onPause(this);
        super.onPause();
    }

	@Override
    protected void onResume() {
        super.onResume();
        AVAnalytics.onResume(this);
        PluginWrapper.onResume();
    }
    
    @Override
    protected void onNewIntent(Intent intent) {
        PluginWrapper.onNewIntent(intent);
        super.onNewIntent(intent);
    }
    
	private boolean isNetworkConnected() {
		ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
		if (cm != null) {
			NetworkInfo networkInfo = cm.getActiveNetworkInfo();
			ArrayList<Integer> networkTypes = new ArrayList<Integer>();
			networkTypes.add(ConnectivityManager.TYPE_WIFI);
			try {
				networkTypes.add(ConnectivityManager.class.getDeclaredField(
						"TYPE_ETHERNET").getInt(null));
			} catch (NoSuchFieldException nsfe) {
			} catch (IllegalAccessException iae) {
				throw new RuntimeException(iae);
			}
			if (networkInfo != null
					&& networkTypes.contains(networkInfo.getType())) {
				return true;
			}
		}
		return false;
	}
	 
	public String getHostIpAddress() {
		WifiManager wifiMgr = (WifiManager) getSystemService(WIFI_SERVICE);
		WifiInfo wifiInfo = wifiMgr.getConnectionInfo();
		int ip = wifiInfo.getIpAddress();
		return ((ip & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF));
	}
	
	public static String getLocalIpAddress() {
		return hostIPAdress;
	}
	
	public static String getSDCardPath() {
		if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
			String strSDCardPathString = Environment.getExternalStorageDirectory().getPath();
           return  strSDCardPathString;
		}
		return null;
	}
	
	public static void onEvent(String eventName, String  tag) {  
		if (context != null) {
			AVAnalytics.onEvent(context, eventName, tag);
		}
	} 
	
	public static void showMail(String mailTitle, String username) {
		Intent i = new Intent(Intent.ACTION_SEND);
		i.setType("message/rfc822");
		i.putExtra(Intent.EXTRA_EMAIL  , new String[]{"beibeidanci@qq.com"});
		i.putExtra(Intent.EXTRA_SUBJECT, mailTitle + ":" + username);
		// i.putExtra(Intent.EXTRA_TEXT   , "(发送反馈邮件)");
		try {
			instance.startActivity(Intent.createChooser(i, "发送反馈邮件"));
		} catch (android.content.ActivityNotFoundException ex) {
		    Toast.makeText(instance, "There are no email clients installed.", Toast.LENGTH_SHORT).show();
		}
	}
	
	public static void downloadFile(final String objectId, final String savepath) {
		AVFile.withObjectIdInBackground(objectId, new GetFileCallback<AVFile>() {
			@Override
			public void done(final AVFile file, AVException e) {
				if (file == null || e != null) {
					invokeLuaCallbackFunctionDL(objectId, file != null ? file.getName() : "", e != null ? e.getLocalizedMessage() : "get file object error", 0);
				} else {
					file.getDataInBackground(new GetDataCallback() {
						@Override
						public void done(byte[] data, AVException arg1) {
							if (arg1 != null) {
								invokeLuaCallbackFunctionDL(objectId, file != null ? file.getName() : "", arg1.getLocalizedMessage(), 0);
							} else {
								if (saveFile(savepath, file.getName(), data)) {
									invokeLuaCallbackFunctionDL(objectId, file.getName(), "save file succeed", 1);
								} else {
									invokeLuaCallbackFunctionDL(objectId, file.getName(), "save file error", 0);
								}
							}
						}
					}, new ProgressCallback() {
						@Override
						public void done(Integer arg0) {
						}						
					});
				}
			}
		});
	}
	
	public static class DWSF {
		
		public DWSF(String[] words, int index, int count, String prefix, String subfix, String path) {
			_words = words;
			_index = index;
			_count = count;
			_prefix = prefix;
			_subfix = subfix;
			_path = path;
		}
		
		public void search() {
			if (_index >= _count) return;
			String filename = _prefix + _words[_index] + _subfix;
			
			AVQuery<AVObject> query = new AVQuery<AVObject>("_File");
			query.whereEqualTo("name", filename);
			query.findInBackground(new FindCallback<AVObject>() {
				@Override
				public void done(List<AVObject> obj, AVException e) {
					if (e == null && obj != null && obj.size() > 0) {						
						download(obj.get(0).getObjectId());						
					} else {
						gotoNext();
					}
				}
			});
		}
		
		private void download(String objectId) {
			AVFile.withObjectIdInBackground(objectId, new GetFileCallback<AVFile>() {
				@Override
				public void done(final AVFile file, AVException e) {
					if (file == null || e != null) {
						gotoNext();
					} else {
						file.getDataInBackground(new GetDataCallback() {
							@Override
							public void done(byte[] data, AVException err) {
								if (err == null) {
									saveFile(_path, file.getName(), data);
								}
								gotoNext();
							}
						});
					}
				}
			});
		}
		
		private void gotoNext() {
			DWSF next = new DWSF(_words, _index + 1, _count, _prefix, _subfix, _path);
			next.search();
		}
		
		private String[] _words;
		private int _index;
		private int _count;
		
		private String _prefix;
		private String _subfix;
		private String _path;
	}
	public static void downloadWordSoundFiles(final String prefix, final String wordsList, final String subfix, final String path) {
		String[] words = wordsList.split("\\|");
		DWSF first = new DWSF(words, 0, words.length, prefix, subfix, path);
		first.search();
	}
	
	private static boolean saveFile(String savepath, String filename, byte[] data) {
		File file = new File(savepath , filename);
        try {
			file.createNewFile();
			FileOutputStream out = new FileOutputStream(file);
			out.write(data);
			out.close();
			return true;
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	private static String AVUserToJsonStr(AVUser user) {
//		TODO: Android unknown error
//		org.json.JSONObject json = user.toJSONObject();
//		return json.toString();
		
		return user.getSessionToken();
	}
	
	public static void signUp(String username, String password) {
		final AVUser user = new AVUser();
		user.setUsername(username);
		user.setPassword(password);
		user.signUpInBackground(new SignUpCallback() {
		    public void done(AVException e) {
		        if (e == null) {
		        	invokeLuaCallbackFunctionSU(AVUserToJsonStr(user), null, 0);
		        } else {
		        	invokeLuaCallbackFunctionSU(null, e.getLocalizedMessage(), e.getCode());
		        }
		    }
		});
	}
	
	public static void logIn(String username, String password) {
		AVUser.logInInBackground(username, password, new LogInCallback<AVUser>() {
			public void done(AVUser user, AVException e) {
		        if (e == null) {
		        	invokeLuaCallbackFunctionLI(AVUserToJsonStr(user), null, 0);
		        } else {
		        	invokeLuaCallbackFunctionLI(null, e.getLocalizedMessage(), e.getCode());
		        }
		    }
		});
	}
	
	public static void logOut() {
		AVUser.logOut();
	}
	
	private static native boolean nativeIsLandScape();
	private static native boolean nativeIsDebug();
	private static native void invokeLuaCallbackFunctionDL(String objectId, String filename, String error, int isSaved);
	private static native void invokeLuaCallbackFunctionSU(String objectjson, String error, int errorcode);
	private static native void invokeLuaCallbackFunctionLI(String objectjson, String error, int errorcode);
}
