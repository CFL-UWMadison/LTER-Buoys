package lter.limnology.wisc.edu.newlakeconditions.utils;

import android.support.design.widget.Snackbar;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import java.util.HashMap;

/**
 *
 * This class stores the explanation for each possible term showed on the in the app
 *
 * Created by xu on 8/7/16.
 */
public class LakeTermWiki {

    public static final String WATER_TEMP_EXPLAIN_KEY = "water_temp_explain";
    public static final String AIR_TEMP_EXPLAIN_KEY = "air_temp_explain";
    public static final String WIND_SPEED_EXPLAIN_KEY = "wind_speed_explain";
    public static final String WIND_DIR_EXPLAIN_KEY = "wind_dir_explain";
    public static final String THERMO_EXPLAIN_KEY = "thermo_explain_key";
    public static final String SECCHI_EXPLAIN_KEY = "secchi_explain_key";
    public static final String WATER_TEMP_EXPLAIN = "Water Temperature";
    public static final String AIR_TEMP_EXPLAIN = "Air Temperature";
    public static final String WIND_SPEED_EXPLAIN ="Current wind speed";
    public static final String WIND_DIR_EXPLAIN = "Wind Direction";
    public static final String THERMO_EXPLAIN = "Thermocline Depth:\n A thin layer of water in the" +
            " lake in which temperature changes most rapidly with depth";
    public static final String SECCHI_EXPLAIN = " \"Secchi Est\" " +
            "The depth at which a Secchi disk (a black & white circular plate)" +
            " disappears from view as it is lowered into the water.";
    public static final String WIND_IMAGE_EXPLAIN ="Wind associated information";
    public static final String WATER_IMAGE_EXPLAIN = "Water associated information";
    public static final String TEMP_IMAGE_EXPLAIN = "Temperature associated information";

    private static HashMap<String,String> wiki;
    private View containerView;

    public LakeTermWiki(){
       this(null);
    }


    public LakeTermWiki(View viewSnackBarLiving){
        this.containerView = viewSnackBarLiving;
    }

    //The snack bar is used for the small size of the
    public void clickViewToShowWIKI(View prompt, final String wikiExplain){
        prompt.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if(event.getAction() == MotionEvent.ACTION_DOWN){
                    Snackbar snackbar = makeWikiSnackBar(wikiExplain);
                    //Probably need to set the text size here
                    snackbar.show();
                    return true;
                }
                return false;
            }
        });
    }

    public void clickViewToShowToastWIKI(View prompt,final String wikiExplain){
        prompt.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if(event.getAction() == MotionEvent.ACTION_DOWN){
                    Toast toast = Toast.makeText(containerView.getContext(),wikiExplain, Toast.LENGTH_SHORT);
                    //Probably need to set the text size here
                    toast.setGravity(Gravity.BOTTOM, 0,0);
                    toast.show();
                    return true;
                }
                return false;
            }
        });
    }

    public void clickViewToShowToastWIKI(View prompt, final String wikiExplain, final int duration){
        prompt.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if(event.getAction() == MotionEvent.ACTION_DOWN){
                    Toast toast = Toast.makeText(containerView.getContext(),wikiExplain, duration);
                    //Probably need to set the text size here
                    toast.setGravity(Gravity.BOTTOM, 0,0);
                    toast.show();
                    return true;
                }
                return false;
            }
        });
    }

    public Snackbar makeWikiSnackBar(String wikiExplain){
        return Snackbar.make(this.containerView,wikiExplain,Snackbar.LENGTH_LONG);
    }
}
