package lter.limnology.wisc.edu.newlakeconditions.utils;

import java.util.LinkedHashMap;
import java.util.Set;

/**
 * This class is used to wrap the function that might be used in the adapter
 * This class extends the LinkedHashMap, and provides some function related
 * to the position in the dictionary. Right now, it's possible to find an item based on
 * the position. It also provides the function that puts a specific item to the first, which
 * will be used in the homepage function.
 *
 * Created by xu on 7/29/16.
 */
public class LakeMaps<K,V> extends LinkedHashMap<K,V> {

    public K[] getKeys(){
        K[] keys= (K[])new Object[this.size()];
        Set<Entry<K,V>> entries = entrySet();

        int i = 0;
        for (Entry entry: entries
             ) {
            keys[i] =(K) entry.getKey();
            i++;
        }

        return keys;
    }

    public V[] getValues(){
        V[] values= (V[])new Object[this.size()];
        Set<Entry<K,V>> entries = entrySet();

        int i = 0;
        for (Entry entry: entries
                ) {
            values[i] =(V) entry.getValue();
            i++;
        }
        return values;
    }

    public K getKeyByPosition(int pos){
        int cursorPos = 0;
        Set<Entry<K,V>> entries = entrySet();
        for (Entry<K,V> entry: entries
                ) {
            if (cursorPos == pos){
                return entry.getKey();
            }

            cursorPos ++;
        }

        throw new IndexOutOfBoundsException();
    }

    /**
     * If you have the duplicate for the value, it will always return the elderest key.
     *
     * @param value
     * @return The key
     */
    public K getKeyByValue(V value){
        Set<Entry<K,V>> entries = entrySet();

        for (Entry<K,V> entry: entries
             ) {
            if (entry.getValue().equals(value)){
                return entry.getKey();
            }
        }
        throw new IllegalArgumentException("The value is not in the map");
    }

    /**
     *  The relative order of other entries will remain the same
     *  This will not change the internal data of the map.
     *
     * @param key the key
     * @return
     */
    public LakeMaps<K, V> insertOneEntryToFirstByKey(K key){
        LakeMaps<K,V> newHashMap = new LakeMaps<>();
        Entry<K,V>[] tempEntry = new Entry[size()];

        // Get the entry set
        Set<Entry<K,V>> entries = entrySet();

        boolean isFirst = true;
        int insertPosition = 1;

        //Create the new order of the entry
        for (Entry<K,V> entry: entries
                ){
            if (entry.getKey().equals(key)){
                if (isFirst){
                    return this;
                }else {
                    tempEntry[0] = entry;
                }
            }else {
               tempEntry[insertPosition] = entry;
                insertPosition ++;
            }
            isFirst = false;
        }

        // Put the new order of entry into the new map
        for (Entry<K,V> entry:tempEntry
                ) {
            newHashMap.put(entry.getKey(),entry.getValue());
        }

        return newHashMap;
    }

    public LakeMaps<K, V> insertOneEntryToFirstByValue(V value){
        K key = null;
        try {
            key = getKeyByValue(value);
        } catch (IllegalArgumentException e){
            return this;
        }
        return insertOneEntryToFirstByKey(key);
    }
}
