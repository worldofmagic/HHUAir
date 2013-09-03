using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HHUAir.Admin
{
    public partial class AirportAdmin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        /// <summary>
        /// 验证输入的信息是否合法
        /// </summary>
        private bool cannotContinue(string name, string city, bool isInsert)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                LabelErrorMessage.Text = "请输入机场名称";
                return true;
            }
            if (string.IsNullOrWhiteSpace(city))
            {
                LabelErrorMessage.Text = "请输入所在城市";
                return true;
            }
            if (name.Length > 20)
            {
                LabelErrorMessage.Text = "机场名称长度不能超过20个字符";
                return true;
            }
            if (city.Length > 20)
            {
                LabelErrorMessage.Text = "所在城市长度不能超过20个字符";
                return true;
            }
            int cnt=(from c in new HHUAirDataContext().Airports where c.Name == name && c.City == city select c).Count();
            if (isInsert ? cnt > 0 : cnt > 1)
            {
                LabelErrorMessage.Text = "相同名称和所在城市的机场已经存在，不能重复添加";
                return true;
            }
            return false;
        }

        protected void GridViewAirports_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            //在更新前检查修改后的信息是否合法，若不合法则取消修改并显示错误提示
            e.Cancel = LabelErrorMessage.Visible = cannotContinue((string)e.NewValues[0], (string)e.NewValues[1], false);
        }

        protected void DetailsViewNewAirport_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            //在插入前检查新增的信息是否合法，若不合法则取消插入并显示错误提示
            e.Cancel = LabelErrorMessage.Visible = cannotContinue((string)e.Values[0], (string)e.Values[1], true);
        }

        protected void GridViewAirports_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            //若选择取消更新，则隐藏错误提示
            LabelErrorMessage.Visible = false;
        }

        protected void DetailsViewNewAirport_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            //若选择取消插入，则隐藏错误提示
            if (e.CommandName == "Cancel")
            {
                LabelErrorMessage.Visible = false;
            }
        }
    }
}