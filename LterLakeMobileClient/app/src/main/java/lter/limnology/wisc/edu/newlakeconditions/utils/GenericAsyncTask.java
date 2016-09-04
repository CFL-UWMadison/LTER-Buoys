package lter.limnology.wisc.edu.newlakeconditions.utils;

import android.os.AsyncTask;
import android.util.Log;

public class GenericAsyncTask<Params,
        Progress,
        Result,
        Ops extends GenericAsyncTaskOps<Params, Progress, Result>>
        extends AsyncTask<Params, Progress, Result> {
    /**
     * Debugging tag used by the Android logger.
     */
    protected final String TAG = getClass().getSimpleName();

    /**
     * Params instance.
     */
    private Params mParam;

    /**
     * Reference to the enclosing Ops object.
     */
    protected Ops mOps;

    /**
     * Constructor initializes the field.
     */
    public GenericAsyncTask(Ops ops) {
        mOps = ops;
    }
    @Override
    protected void onPreExecute() {
        Log.i("***********GenericAsyncTask", "onPreExecute********");
    }

    /**
     * Run in a background thread to avoid blocking the UI thread.
     */
    @SuppressWarnings("unchecked")
    protected Result doInBackground(Params... params) {
        Log.i("***********GenericAsyncTask", "doInBackground********");
        mParam = params[0];

        return mOps.doInBackground(mParam);
    }

    /**
     * Process results in the UI Thread.
     */
    protected void onPostExecute(Result result) {
        mOps.onPostExecute(result,
                mParam);
    }
}