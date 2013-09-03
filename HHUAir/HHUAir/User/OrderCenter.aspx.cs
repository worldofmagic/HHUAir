using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HHUAir.User
{
    public partial class OrderCenter : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //只检索当前用户的订单
            SqlDataSourceOrders.SelectCommand = string.Format("SELECT * FROM [Orders] WHERE UserId IN (SELECT UserId from [aspnet_Users] WHERE UserName='{0}')", User.Identity.Name);
            //绑定数据
            GridViewOrders.DataBind();
        }
    }
}