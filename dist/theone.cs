
namespace caiyunlin.com
{
    public sealed class TheOne{

        /// <summary>
        /// 生成MD5
        /// </summary>
        public string MD5(string input){
            return null;
        }

        /// <summary> 
        /// 在C#中指定修订号为*的时候，修订号则是一个时间戳，我们可以从其得到编译日期
        /// 生成和修订版本号必须是自动生成的
        /// AssemblyInfo里的写法应该为1.0之后为.*
        /// [assembly: AssemblyVersion("1.0.*")]
        /// </summary>
        /// <returns></returns>
        public DateTime GetBuildDateTime()
        {
            /*
             * version = 1.0.3420.56234
             * 这里主版本号是1，次版本号是0，而生成和修订版本号是自动生成的。
             * 使用*时，生成号是从2000年1月1日开始的天数，而修订号是从凌晨开始的秒数除以2。
             */
            string version = System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString();
            int days = 0;
            int seconds = 0;
            string[] v = version.Split('.');
            if (v.Length == 4)
            {
                days = Convert.ToInt32(v[2]);
                seconds = Convert.ToInt32(v[3]);
            }
            DateTime dt = new DateTime(2000, 1, 1);
            dt = dt.AddDays(days);
            dt = dt.AddSeconds(seconds * 2);
            return dt;
        }
    }
}

