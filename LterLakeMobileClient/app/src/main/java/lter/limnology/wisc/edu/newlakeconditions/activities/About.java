package lter.limnology.wisc.edu.newlakeconditions.activities;

import android.app.Activity;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;

import lter.limnology.wisc.edu.newlakeconditions.R;

/**
 *
 */
public class About extends AppCompatActivity{

    Button mOk;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.disclaimer);
        mOk = (Button) findViewById(R.id.ok);
        mOk.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }
}
