package lter.limnology.wisc.edu.newlakeconditions.utils;

/**
 *
 */
public interface GenericAsyncTaskOps<Params, Progress, Result> {

    void onPreExecute();

    /**
     * Process the @a param in a background thread.
     */
    Result doInBackground(Params param);

    /**
     * Process the @a result in the UI Thread.
     */
    void onPostExecute(Result result,
                       Params param);
}

