using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class TextGCU : MonoBehaviour
{
    //打字的时间间隔
    public float TimeInterval = 0.3f;
    private string words;//保存需要显示的文字

    private bool isActive = false;
    private float timer;//时间计时
    private Text myText;
    private int currentPos = 0;//当前打字位置

    void Start()
    {
        timer = 0;
        isActive = true;
        TimeInterval = Mathf.Max(0.2f, TimeInterval);
        myText = GetComponent<Text>();
        words = myText.text;

        //获取Text的文本信息，保存到words中，然后动态更新文本显示内容，实现打字机的效果
        myText.text = "";
    }

    void Update()
    {
        OnStartWriter();
    }

    public void StartEffect()
    {
        isActive = true;
    }

    /// <summary>
    /// 开始打字
    /// </summary>
    void OnStartWriter()
    {

        if (isActive)
        {
            timer += Time.deltaTime;
            print(TimeInterval);
            if (timer >= TimeInterval)
            {
                //判断计时器时间是否完成
                timer = 0;
                currentPos++;
                myText.text = words.Substring(0, currentPos);//刷新显示内容

                if (currentPos >= words.Length)
                {
                    OnFinish();
                }
            }

        }
    }

    /// <summary>
    /// 结束打字，初始化数据
    /// </summary>
    void OnFinish()
    {
        isActive = false;
        timer = 0;
        currentPos = 0;
        myText.text = words;
    }
}