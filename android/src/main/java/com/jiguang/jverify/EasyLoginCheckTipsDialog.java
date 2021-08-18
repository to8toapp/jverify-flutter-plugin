package com.jiguang.jverify;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Point;
import android.os.Bundle;
import android.text.SpannableStringBuilder;
import android.text.method.LinkMovementMethod;
import android.view.Display;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import androidx.annotation.NonNull;


/**
 * 案例详情反馈弹窗
 *
 * @Author reus.shi
 * @Date 2021/8/4 13:50
 * @Version 1.0
 */
public class EasyLoginCheckTipsDialog extends Dialog {


    private Context mContext;
    private IOnEasyLoginListener onEasyLoginListener;

    private CharSequence mProtocolText;

    public EasyLoginCheckTipsDialog(@NonNull Context context) {
        super(context, R.style.dialog_case_detail_feedback);
        mContext = context;
    }

    public EasyLoginCheckTipsDialog(@NonNull Context context, int themeResId) {
        super(context, R.style.dialog_case_detail_feedback);
        mContext = context;
    }


    /**
     * 构造器
     *
     * @param context
     * @param onEasyLoginListener
     */
    public EasyLoginCheckTipsDialog(@NonNull Context context, CharSequence protocolText, IOnEasyLoginListener onEasyLoginListener) {
        super(context, R.style.dialog_case_detail_feedback);
        mContext = context;
        mProtocolText = protocolText;
        this.onEasyLoginListener = onEasyLoginListener;
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initView();
    }

    public int getScreenWidth(Context context){
        WindowManager windowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        Display defaultDisplay = windowManager.getDefaultDisplay();
        Point point = new Point();
        defaultDisplay.getSize(point);
        int x = point.x;
        return x;
    }

    /**
     * 初始化
     */
    private void initView() {
        setContentView(R.layout.dialog_easy_login_check_tips);
        setCanceledOnTouchOutside(false);
        int width = getScreenWidth(getContext());
        Window dialogWindow = getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        dialogWindow.setGravity(Gravity.CENTER);
        // 宽度
        lp.width = (int)(width * 0.9);
        // 高度
        lp.height = WindowManager.LayoutParams.WRAP_CONTENT;

        TextView tvTitle = findViewById(R.id.tv_title);
        TextView tvContent = findViewById(R.id.tv_content);

        SpannableStringBuilder spannableStringBuilder = SpannableStringBuilder.valueOf(mProtocolText);
        spannableStringBuilder.delete(0,6);
        spannableStringBuilder.append("可继续登录");

        tvContent.setText(spannableStringBuilder);
        tvContent.setClickable(true);
        tvContent.setMovementMethod(LinkMovementMethod.getInstance());//需要处理点击得加这句

        //提交
        findViewById(R.id.btn_agree).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onEasyLoginListener != null) {
                    onEasyLoginListener.onAgreeClicked();
                }
            }
        });


        //关闭
        findViewById(R.id.btn_cancel).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });

        findViewById(R.id.iv_close).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });
    }


    public interface IOnEasyLoginListener {
        void onAgreeClicked();
    }




}
