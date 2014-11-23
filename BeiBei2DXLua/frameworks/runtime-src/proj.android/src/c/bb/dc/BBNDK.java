package c.bb.dc;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Environment;
import android.widget.Toast;

import com.avos.avoscloud.AVAnalytics;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVFile;
import com.avos.avoscloud.AVUser;
import com.avos.avoscloud.GetDataCallback;
import com.avos.avoscloud.GetFileCallback;
import com.avos.avoscloud.LogInCallback;
import com.avos.avoscloud.ProgressCallback;
import com.avos.avoscloud.SignUpCallback;

public class BBNDK {
	private static String _hostIPAdress = "0.0.0.0";
	private static Context _context = null;
	private static Activity _instance = null;
	
	public static Context getContext() {
		return _context;
	}

	public static void setup(Context context, Activity instance) {
		_context = context;
		_instance = instance;
	}
	
	// ***************************************************************************************************************************
	// cocos2d-x runtime
	// ***************************************************************************************************************************
	
	public static void setHostIPAdress(String hostIPAdress) {
		_hostIPAdress = hostIPAdress;
	}
	
	public static String getLocalIpAddress() {
		return _hostIPAdress;
	}
	
	public static String getSDCardPath() {
		if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
			String strSDCardPathString = Environment.getExternalStorageDirectory().getPath();
           return  strSDCardPathString;
		}
		return null;
	} 
	
	// ***************************************************************************************************************************
	// feedback
	// ***************************************************************************************************************************
	
	public static void showMail(String mailTitle, String username) {
		Intent i = new Intent(Intent.ACTION_SEND);
		i.setType("message/rfc822");
		i.putExtra(Intent.EXTRA_EMAIL  , new String[]{"beibeidanci@qq.com"});
		i.putExtra(Intent.EXTRA_SUBJECT, mailTitle + ":" + username);
		i.putExtra(Intent.EXTRA_TEXT   , "这是我的反馈，贝贝请认真看哦!\n");
		try {
			_instance.startActivity(Intent.createChooser(i, "发送反馈邮件"));
		} catch (android.content.ActivityNotFoundException ex) {
		    Toast.makeText(_instance, "There are no email clients installed.", Toast.LENGTH_SHORT).show();
		}
	}
	
	// ***************************************************************************************************************************
	// LeanCloud AVAnalytics
	// ***************************************************************************************************************************
	
	public static void onEvent(String eventName, String  tag) {  
		if (_context != null) {
			AVAnalytics.onEvent(_context, eventName, tag);
		}
	}
	
	// ***************************************************************************************************************************
	// LeanCloud download
	// ***************************************************************************************************************************
	
	public static void downloadFile(final String objectId, final String savepath) {
		AVFile.withObjectIdInBackground(objectId, new GetFileCallback<AVFile>() {
			@Override
			public void done(final AVFile file, AVException e) {
				if (file == null || e != null) {
					invokeLuaCallbackFunctionDL(objectId, file != null ? file.getOriginalName() : "", e != null ? e.getLocalizedMessage() : "get file object error", 0);
				} else {
					file.getDataInBackground(new GetDataCallback() {
						@Override
						public void done(byte[] data, AVException arg1) {
							if (arg1 != null) {
								invokeLuaCallbackFunctionDL(objectId, file != null ? file.getOriginalName() : "", arg1.getLocalizedMessage(), 0);
							} else {
								if (data != null && data.length > 0 && BBUtils.saveFile(savepath, file.getOriginalName(), data)) {
									invokeLuaCallbackFunctionDL(objectId, file.getOriginalName(), "save file succeed", 1);
								} else {
									invokeLuaCallbackFunctionDL(objectId, file.getOriginalName(), "save file error", 0);
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
	
	public static void downloadWordSoundFiles(final String prefix, final String wordsList, final String subfix, final String path) {
		String[] words = wordsList.split("\\|");
		BBWordSoundFileDownloader first = new BBWordSoundFileDownloader(words, 0, words.length, prefix, subfix, path);
		first.start();
	}
	
	public static void downloadConfigFiles(final String objectIds, final String path) {
		String[] ids = objectIds.split("\\|");
		BBConfigsDownloader o = new BBConfigsDownloader(ids, 0, ids.length, path);
		o.start();
	}
	
	// ***************************************************************************************************************************
	// LeanCloud sign up, log in, log out
	// ***************************************************************************************************************************
	
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
	
	// ***************************************************************************************************************************
	// loading circle
	// ***************************************************************************************************************************
	
	private static BBProgressHUD _cxph = null;
	
	public static void showCXProgressHUD(String content) {
//		if (_cxph == null) {
//			_cxph = new BBProgressHUD();
//			_cxph.setContent(content);
//		}
//		_cxph.execute();
	}
	
	public static void hideCXProgressHUD() {
//		if (_cxph != null) {
//			_cxph.hide();
//		}
	}
	
	// ***************************************************************************************************************************
	// native
	// ***************************************************************************************************************************
	
	public static native boolean nativeIsLandScape();
	public static native boolean nativeIsDebug();
	public static native void invokeLuaCallbackFunctionDL(String objectId, String filename, String error, int isSaved);
	public static native void invokeLuaCallbackFunctionSU(String objectjson, String error, int errorcode);
	public static native void invokeLuaCallbackFunctionLI(String objectjson, String error, int errorcode);
}
