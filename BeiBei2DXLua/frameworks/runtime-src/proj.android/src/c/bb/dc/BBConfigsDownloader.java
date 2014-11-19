package c.bb.dc;

public class BBConfigsDownloader extends BBDownloader {
	public BBConfigsDownloader(String[] objIds, int index, int count, String path) {
		_objIds = objIds;
		_index = index;
		_count = count;
		_path = path;
	}
	
	@Override
	public void start() {
		if (_index >= _count) return;
		download(_objIds[_index]);
	}
	
	@Override
	protected void gotoNext() {
		_index++;
		if (_index >= _count) return;
		download(_objIds[_index]);
	}
	
	private String[] _objIds;
	private int _index;
	private int _count;
}
