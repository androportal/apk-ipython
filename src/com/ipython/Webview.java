package com.ipython;

import android.os.Bundle;
import android.app.Activity;
import android.view.Menu;
import android.webkit.WebView;

public class Webview extends Activity {

	private WebView ipython;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_webview);
        
        ipython = (WebView) findViewById(R.id.webview);
        ipython.getSettings().setJavaScriptEnabled(true);
        ipython.loadUrl("http://127.0.0.1:8888/");
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.activity_webview, menu);
        return true;
    }
}
