using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace HHUAir.Admin
{
    public partial class ModelAdmin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        /// <summary>
        /// 验证输入的信息是否合法
        /// </summary>
        private bool cannotContinue(string name, string type, string maxSeats, string minSeats, bool isInsert)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                LabelErrorMessage.Text = "请输入机型名称";
                return true;
            }
            if (string.IsNullOrWhiteSpace(type))
            {
                LabelErrorMessage.Text = "请输入所属类型";
                return true;
            }
            if (name.Length > 20)
            {
                LabelErrorMessage.Text = "机型名称长度不能超过20个字符";
                return true;
            }
            if (type.Length > 20)
            {
                LabelErrorMessage.Text = "所属类型长度不能超过20个字符";
                return true;
            }
            if (string.IsNullOrWhiteSpace(maxSeats))
            {
                LabelErrorMessage.Text = "请输入最多座位数";
                return true;
            }
            if (string.IsNullOrWhiteSpace(minSeats))
            {
                LabelErrorMessage.Text = "请输入最少座位数";
                return true;
            }
            int max, min;
            int.TryParse(maxSeats, out max);
            if (max <= 0)
            {
                LabelErrorMessage.Text = "请正确输入最多座位数";
                return true;
            }
            int.TryParse(minSeats, out min);
            if (min <= 0)
            {
                LabelErrorMessage.Text = "请正确输入最少座位数";
                return true;
            }
            if (max < min)
            {
                LabelErrorMessage.Text = "最多座位数必须大于等于最少座位数";
                return true;
            }
            int cnt = (from c in new HHUAirDataContext().Models where c.Name == name select c).Count();
            if (isInsert ? cnt > 0 : cnt > 1)
            {
                LabelErrorMessage.Text = "相同名称的机型已经存在，不能重复添加";
                return true;
            }
            return false;
        }

        protected void GridViewModels_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            //在更新前检查修改后的信息是否合法，若不合法则取消修改并显示错误提示
            e.Cancel = LabelErrorMessage.Visible
                = cannotContinue((string)e.NewValues[0], (string)e.NewValues[1], (string)e.NewValues[2], (string)e.NewValues[3], false);
        }

        protected void DetailsViewNewModel_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            //在插入前检查新增的信息是否合法，若不合法则取消插入并显示错误提示
            e.Cancel = LabelErrorMessage.Visible
                = cannotContinue((string)e.Values[0], (string)e.Values[1], (string)e.Values[2], (string)e.Values[3], true);
        }

        protected void GridViewModels_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            //若选择取消更新，则隐藏错误提示
            LabelErrorMessage.Visible = false;
        }

        protected void DetailsViewNewModel_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            //若选择取消插入，则隐藏错误提示
            if (e.CommandName == "Cancel")
            {
                LabelErrorMessage.Visible = false;
            }
        }
    }
}