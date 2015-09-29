package lter.limnology.wisc.edu.lterlakeconditions.activities;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import lter.limnology.wisc.edu.lterlakeconditions.R;

/**
 * Created by Shweta Nagar on 9/12/15.
 */
public class About extends Activity{

    Button mOk;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.about);
        mOk = (Button) findViewById(R.id.ok);
        mOk.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }
}
