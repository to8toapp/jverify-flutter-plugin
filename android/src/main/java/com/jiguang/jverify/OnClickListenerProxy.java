package com.jiguang.jverify;

import android.util.Log;
import android.view.View;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

/**
 * 实现点击监听
 */
public class OnClickListenerProxy implements View.OnClickListener{
    private View.OnClickListener mOriginalListener;
    private View.OnClickListener mNewListener;

    //直接在构造函数中传进来原来的OnClickListener
    public OnClickListenerProxy(View.OnClickListener originalListener, View.OnClickListener newListener) {
        mOriginalListener = originalListener;
        mNewListener = newListener;
    }

    @Override public void onClick(View v) {

        if (mNewListener != null) {
            mNewListener.onClick(v);
        }
    }

    public static View.OnClickListener hookOnClickListener(View view, View.OnClickListener newListener) {
        try {
            // 得到 View 的 ListenerInfo 对象
            Method getListenerInfo = View.class.getDeclaredMethod("getListenerInfo");
            //修改getListenerInfo为可访问(View中的getListenerInfo不是public)
            getListenerInfo.setAccessible(true);
            Object listenerInfo = getListenerInfo.invoke(view);
            // 得到 原始的 OnClickListener 对象
            Class<?> listenerInfoClz = Class.forName("android.view.View$ListenerInfo");
            Field mOnClickListener = listenerInfoClz.getDeclaredField("mOnClickListener");
            mOnClickListener.setAccessible(true);
            View.OnClickListener originOnClickListener = (View.OnClickListener) mOnClickListener.get(listenerInfo);
            // 用自定义的 OnClickListener 替换原始的 OnClickListener
            View.OnClickListener hookedOnClickListener = new OnClickListenerProxy(originOnClickListener, newListener);
            mOnClickListener.set(listenerInfo, hookedOnClickListener);
            return originOnClickListener;
        } catch (Exception e) {
            Log.d("LOGCAT","hook clickListener failed!", e);
            return null;
        }
    }
}
