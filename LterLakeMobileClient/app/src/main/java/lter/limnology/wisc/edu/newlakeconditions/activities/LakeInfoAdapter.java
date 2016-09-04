package lter.limnology.wisc.edu.newlakeconditions.activities;

import android.content.SharedPreferences;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import java.util.Map;
import java.util.Set;

import lter.limnology.wisc.edu.newlakeconditions.utils.LakeMaps;

/**
 * I need to hard code the number and the name of the lakes due to the fact that
 * I don't know how to change the database to make the adapter dynamically know the
 * number of the lakes, but I will try to make it easy to extend in the future by using
 * generic thing.
 *
 * Created by xu on 7/10/16.
 */
public class LakeInfoAdapter extends FragmentPagerAdapter{

    private LakeMaps<String,String> lakeMap;
    private SharedPreferences userSetting;

    NewFragmentCreatedListener nfcListener;

    //Let's see whether we can save the weather ops into the Fragment.
    public interface NewFragmentCreatedListener{
        public void onNewFragmentCreatedListener(LakeConditions newinstance, int position);
    }

    public String[] getLakeIds(){
        String[] lakeids = new String[lakeMap.size()];
        Set<Map.Entry<String,String>> set = lakeMap.entrySet();
        int i = 0;
        for (Map.Entry entry:set) {
            lakeids[i] =(String) entry.getValue();
            i++;
        }

        return lakeids;
    }

    public LakeInfoAdapter(FragmentManager fm){
        super(fm);

        // Create a lake Map. This map will contain both lake name and its
        // id, which will help relate the tab to its fragment. lake name is
        // the key, and the id is the value. Avoid too much hardcode.
        lakeMap = new LakeMaps<String, String>();
        lakeMap.put("Lake Mendota","ME");
        lakeMap.put( "Trout Lake","TR");
        lakeMap.put("Sparkling Lake","SP");


    }

    @Override
    public int getCount() {
        return lakeMap.size();
    }

    public void setHomepageAsFirstInLakeMap(String homepageID){
       // this.userSetting = userSetting;

        //reorder the hashmap. The first one will be the homepage id in user preference
        if (homepageID != null){
            this.lakeMap = lakeMap.insertOneEntryToFirstByValue(homepageID);
        }
    }


    //If I ask model to deal with the data, how does the model which data it should send to.
    // This will only be called for the first time.
    @Override
    public Fragment getItem(int position) {

        String title = (String) getPageTitle(position);
        String lakeID = (String) this.lakeMap.get(title);
        LakeConditions temp = LakeConditions.newinstance(lakeID);
        //this.nfcListener.onNewFragmentCreatedListener(temp, position);

        return temp;
    }

    @Override
    public CharSequence getPageTitle(int position) {
        return lakeMap.getKeyByPosition(position);
    }

    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }


    public void setNfcListener(NewFragmentCreatedListener fragmentCreatedListener){
        this.nfcListener = fragmentCreatedListener;
    }
}
