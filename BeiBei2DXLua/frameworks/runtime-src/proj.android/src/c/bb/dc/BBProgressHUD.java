package c.bb.dc;

//import com.walnutlabs.android.ProgressHUD;

import android.content.DialogInterface;
import android.content.DialogInterface.OnCancelListener;
import android.os.AsyncTask;
import android.app.ProgressDialog;

public class BBProgressHUD extends AsyncTask<Void, String, Void> implements OnCancelListener {
	public enum state {STATE_INIT, STATE_ING, STATE_DONE};
	
	private state mState = state.STATE_INIT;
	private String mContent = "";
	private ProgressDialog mProgressHUD = null;
	
	public void setContent(String content) {
		mContent = content;
	}
	
	public void hide() {
		mState = state.STATE_DONE;
	}
	
	@Override
	protected void onPreExecute() {
		mState = state.STATE_ING;
		mProgressHUD = ProgressDialog.show(BBNDK.getContext(), "Loading", "", true);
		super.onPreExecute();
	}
	
	@Override
	protected void onPostExecute(Void result) {
		mProgressHUD.dismiss();
		super.onPostExecute(result);
	}
	
	@Override
	public void onCancel(DialogInterface dialog) {
		this.cancel(true);
		mProgressHUD.dismiss();
	}

	@Override
	protected Void doInBackground(Void... params) {
		while (mState != state.STATE_DONE) {
			
		}
		
		return null;
	}

}
