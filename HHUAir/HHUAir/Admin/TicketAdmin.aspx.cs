using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HHUAir.Admin
{
    public partial class TicketAdmin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        /// <summary>
        /// 验证输入的信息是否合法
        /// </summary>
        private bool cannotContinue(string flightNumber, string departAirport,string arrivalAirport,string departDatetime, string arrivalDatetime, string originalPrice, string currentPrice, string amount, string soldAmout,bool isInsert)
        {
            if (string.IsNullOrWhiteSpace(flightNumber))
            {
                LabelErrorMessage.Text = "请输入航班号";
                return true;
            }
            bool isFlightNumberLegal = true;
            if (flightNumber.Length != 10)
            {
                isFlightNumberLegal = false;
            }
            else
            {
                char[] fns = flightNumber.ToCharArray();
                foreach (char c in fns)
                {
                    if (!((c >= '0' && c <= '9') || (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')))
                    {
                        isFlightNumberLegal = false;
                        break;
                    }
                }
            }
            if (!isFlightNumberLegal)
            {
                LabelErrorMessage.Text = "航班号格式为10个字母或数字";
                return true;
            }
            if (string.IsNullOrWhiteSpace(departDatetime))
            {
                LabelErrorMessage.Text = "请输入出发时间";
                return true;
            }
            if (string.IsNullOrWhiteSpace(arrivalDatetime))
            {
                LabelErrorMessage.Text = "请输入抵达时间";
                return true;
            }
            if (string.IsNullOrWhiteSpace(originalPrice))
            {
                LabelErrorMessage.Text = "请输入原始票价";
                return true;
            }
            if (string.IsNullOrWhiteSpace(currentPrice))
            {
                LabelErrorMessage.Text = "请输入当前票价";
                return true;
            }
            if (string.IsNullOrWhiteSpace(amount))
            {
                LabelErrorMessage.Text = "请输入合计票数";
                return true;
            }
            if (string.IsNullOrWhiteSpace(soldAmout))
            {
                LabelErrorMessage.Text = "请输入售出票数";
                return true;
            }
            if (departAirport == arrivalAirport)
            {
                LabelErrorMessage.Text = "出发机场和抵达机场不能相同";
                return true;
            }
            double op, cp;
            double.TryParse(originalPrice, out op);
            if (op <= 0.0)
            {
                LabelErrorMessage.Text = "请正确输入原始票价";
                return true;
            }
            double.TryParse(originalPrice, out cp);
            if (cp <= 0.0)
            {
                LabelErrorMessage.Text = "请正确输入当前票价";
                return true;
            }
            int a, sa;
            int.TryParse(amount, out a);
            if (a <= 0)
            {
                LabelErrorMessage.Text = "请正确输入合计票数";
                return true;
            }
            if ((!int.TryParse(amount, out sa)) || sa < 0)
            {
                LabelErrorMessage.Text = "请正确输入售出票数";
                return true;
            }
            if (a < sa)
            {
                LabelErrorMessage.Text = "合计票数必须大于等于售出票数";
                return true;
            }
            DateTime dd, ad;
            if (!DateTime.TryParse(departDatetime, out dd))
            {
                LabelErrorMessage.Text = "请正确输入出发时间";
                return true;
            }
            if (!DateTime.TryParse(arrivalDatetime, out ad))
            {
                LabelErrorMessage.Text = "请正确输入抵达时间";
                return true;
            }
            if (ad <= dd)
            {
                LabelErrorMessage.Text = "抵达时间必须晚于出发时间";
                return true;
            }
            var context = new HHUAirDataContext();
            int cnt=(from c in context.Tickets where c.FlightNumber == flightNumber && c.DepartDatetime == dd select c).Count();
            if (isInsert ? cnt > 0 : cnt > 1)
            {
                LabelErrorMessage.Text = "相同航班号和出发时间的机票已经存在，不能重复添加";
                return true;
            }
            cnt = (from c in context.Orders where c.FlightNumber == flightNumber && c.DepartDatetime == dd select c).Count();
            if (cnt > 0 && sa < cnt)
            {
                LabelErrorMessage.Text = "设定的售出票数必须大于等于实际售出票数";
                return true;
            }
            return false;
        }

        protected void DropDownListDepartCity_SelectedIndexChanged(object sender, EventArgs e)
        {
            //在选择的城市发生变化后，检索数据库找到该城市的所有机场并更新机场列表
            DropDownList DropDownListDepartCity = (DropDownList)GridViewTickets.Rows[GridViewTickets.EditIndex].Cells[1].FindControl("DropDownListDepartCity");
            DropDownList DropDownListDepartAirport = (DropDownList)GridViewTickets.Rows[GridViewTickets.EditIndex].Cells[1].FindControl("DropDownListDepartAirport");
            DropDownListDepartAirport.Items.Clear();
            var cities = from c in new HHUAirDataContext().Airports where c.City == DropDownListDepartCity.SelectedValue select c.Name;
            foreach (var city in cities)
            {
                DropDownListDepartAirport.Items.Add(city);
            }
        }

        protected void DropDownListDepartAirport_PreRender(object sender, EventArgs e)
        {
            DropDownListDepartCity_SelectedIndexChanged(null, null);
        }

        protected void DropDownListArrivalCity_SelectedIndexChanged(object sender, EventArgs e)
        {
            //在选择的城市发生变化后，检索数据库找到该城市的所有机场并更新机场列表
            DropDownList DropDownListArrivalCity = (DropDownList)GridViewTickets.Rows[GridViewTickets.EditIndex].Cells[2].FindControl("DropDownListArrivalCity");
            DropDownList DropDownListArrivalAirport = (DropDownList)GridViewTickets.Rows[GridViewTickets.EditIndex].Cells[2].FindControl("DropDownListArrivalAirport");
            DropDownListArrivalAirport.Items.Clear();
            var cities = from c in new HHUAirDataContext().Airports where c.City == DropDownListArrivalCity.SelectedValue select c.Name;
            foreach (var city in cities)
            {
                DropDownListArrivalAirport.Items.Add(city);
            }
        }

        protected void DropDownListArrivalAirport_PreRender(object sender, EventArgs e)
        {
            DropDownListArrivalCity_SelectedIndexChanged(null, null);
        }

        protected void DropDownListDepartCity_New_SelectedIndexChanged(object sender, EventArgs e)
        {
            //在选择的城市发生变化后，检索数据库找到该城市的所有机场并更新机场列表
            DropDownList DropDownListDepartCity = (DropDownList)DetailsViewNewTicket.Rows[1].Cells[1].FindControl("DropDownListDepartCity");
            DropDownList DropDownListDepartAirport = (DropDownList)DetailsViewNewTicket.Rows[1].Cells[1].FindControl("DropDownListDepartAirport");
            DropDownListDepartAirport.Items.Clear();
            var cities = from c in new HHUAirDataContext().Airports where c.City == DropDownListDepartCity.SelectedValue select c.Name;
            foreach (var city in cities)
            {
                DropDownListDepartAirport.Items.Add(city);
            }
        }

        protected void DropDownListDepartAirport_New_PreRender(object sender, EventArgs e)
        {
            DropDownListDepartCity_New_SelectedIndexChanged(null, null);
        }

        protected void DropDownListArrivalCity_New_SelectedIndexChanged(object sender, EventArgs e)
        {
            //在选择的城市发生变化后，检索数据库找到该城市的所有机场并更新机场列表
            DropDownList DropDownListArrivalCity = (DropDownList)DetailsViewNewTicket.Rows[2].Cells[1].FindControl("DropDownListArrivalCity");
            DropDownList DropDownListArrivalAirport = (DropDownList)DetailsViewNewTicket.Rows[2].Cells[1].FindControl("DropDownListArrivalAirport");
            DropDownListArrivalAirport.Items.Clear();
            var cities = from c in new HHUAirDataContext().Airports where c.City == DropDownListArrivalCity.SelectedValue select c.Name;
            foreach (var city in cities)
            {
                DropDownListArrivalAirport.Items.Add(city);
            }
        }

        protected void DropDownListArrivalAirport_New_PreRender(object sender, EventArgs e)
        {
            DropDownListArrivalCity_New_SelectedIndexChanged(null, null);
        }

        protected void GridViewTickets_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            //在更新前检查修改后的信息是否合法，若不合法则取消修改并显示错误提示
            e.Cancel = LabelErrorMessage.Visible = cannotContinue(
                ((TextBox)GridViewTickets.Rows[GridViewTickets.EditIndex].Cells[0].FindControl("TextBoxFlightNumber")).Text
                , ((DropDownList)GridViewTickets.Rows[GridViewTickets.EditIndex].Cells[1].FindControl("DropDownListDepartAirport")).SelectedValue
                , ((DropDownList)GridViewTickets.Rows[GridViewTickets.EditIndex].Cells[2].FindControl("DropDownListArrivalAirport")).SelectedValue
                , ((TextBox)GridViewTickets.Rows[GridViewTickets.EditIndex].Cells[1].FindControl("TextBoxDepartDatetime")).Text
                , ((TextBox)GridViewTickets.Rows[GridViewTickets.EditIndex].Cells[2].FindControl("TextBoxArrivalDatetime")).Text
                , ((TextBox)GridViewTickets.Rows[GridViewTickets.EditIndex].Cells[4].FindControl("TextBoxOriginalPrice")).Text
                , ((TextBox)GridViewTickets.Rows[GridViewTickets.EditIndex].Cells[4].FindControl("TextBoxCurrentPrice")).Text
                , ((TextBox)GridViewTickets.Rows[GridViewTickets.EditIndex].Cells[4].FindControl("TextBoxAmount")).Text
                , ((TextBox)GridViewTickets.Rows[GridViewTickets.EditIndex].Cells[4].FindControl("TextBoxSoldAmount")).Text
                , false
                );
        }

        protected void DetailsViewNewTicket_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            //在插入前检查新增的信息是否合法，若不合法则取消插入并显示错误提示
            e.Cancel = LabelErrorMessage.Visible = cannotContinue(
                ((TextBox)DetailsViewNewTicket.Rows[0].Cells[1].FindControl("TextBoxFlightNumber")).Text
                , ((DropDownList)DetailsViewNewTicket.Rows[1].Cells[1].FindControl("DropDownListDepartAirport")).SelectedValue
                , ((DropDownList)DetailsViewNewTicket.Rows[2].Cells[1].FindControl("DropDownListArrivalAirport")).SelectedValue
                , ((TextBox)DetailsViewNewTicket.Rows[1].Cells[1].FindControl("TextBoxDepartDatetime")).Text
                , ((TextBox)DetailsViewNewTicket.Rows[2].Cells[1].FindControl("TextBoxArrivalDatetime")).Text
                , ((TextBox)DetailsViewNewTicket.Rows[4].Cells[1].FindControl("TextBoxOriginalPrice")).Text
                , ((TextBox)DetailsViewNewTicket.Rows[4].Cells[1].FindControl("TextBoxCurrentPrice")).Text
                , ((TextBox)DetailsViewNewTicket.Rows[4].Cells[1].FindControl("TextBoxAmount")).Text
                , ((TextBox)DetailsViewNewTicket.Rows[4].Cells[1].FindControl("TextBoxSoldAmount")).Text
                , true
                );
        }

        protected void GridViewTickets_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            //若选择取消更新，则隐藏错误提示
            LabelErrorMessage.Visible = false;
        }

        protected void DetailsViewNewTicket_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            //若选择取消插入，则隐藏错误提示
            if (e.CommandName == "Cancel")
            {
                LabelErrorMessage.Visible = false;
            }
        }

        protected void ButtonDeleteExpired_Click(object sender, EventArgs e)
        {
            var context = new HHUAirDataContext();
            var tickets = from c in context.Tickets where c.DepartDatetime < DateTime.Now select c;
            foreach (var ticket in tickets)
            {
                context.Tickets.DeleteOnSubmit(ticket);
            }
            context.SubmitChanges();
            GridViewTickets.DataBind();
        }
    }
}