package c.bb.dc;

import java.util.List;

import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.AVQuery;
import com.avos.avoscloud.FindCallback;

public class BBWordSoundFileDownloader extends BBDownloader {
	public BBWordSoundFileDownloader(String[] words, int index, int count, String prefix, String subfix, String path) {
		_words = words;
		_index = index;
		_count = count;
		_prefix = prefix;
		_subfix = subfix;
		_path = path;
	}
	
	@Override
	public void start() {
		if (_index >= _count) return;
		search();
	}
	
	protected void search() {
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
	
	@Override
	protected void gotoNext() {
		BBWordSoundFileDownloader next = new BBWordSoundFileDownloader(_words, _index + 1, _count, _prefix, _subfix, _path);
		next.search();
	}
	
	private String[] _words;
	private int _index;
	private int _count;
	
	private String _prefix;
	private String _subfix;
}
