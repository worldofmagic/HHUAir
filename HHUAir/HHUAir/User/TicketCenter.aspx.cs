using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

namespace HHUAir.User
{
    public partial class TicketCenter : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                CalendarDepartDatetime.SelectedDate = DateTime.Now;
            }
        }

        protected void DropDownListDepartCities_SelectedIndexChanged(object sender, EventArgs e)
        {
            //在城市下拉列表中选择城市后，更新文本框中输入的城市名称
            TextBoxDepartCity.Text = DropDownListDepartCities.SelectedValue;
        }

        protected void DropDownListArrivalCities_SelectedIndexChanged(object sender, EventArgs e)
        {
            //在城市下拉列表中选择城市后，更新文本框中输入的城市名称
            TextBoxArrivalCity.Text = DropDownListArrivalCities.SelectedValue;
        }

        protected void ButtonFilter_Click(object sender, EventArgs e)
        {
            //筛选符合条件的机票
            StringBuilder command = new StringBuilder("SELECT [FlightNumber], [DepartAirport], [ArrivalAirport], [DepartCity], [ArrivalCity], [DepartDatetime], [ArrivalDatetime], [ModelName], CONVERT(numeric(18, 2), [OriginalPrice]) AS OriginalPrice, CONVERT(numeric(18, 2), [CurrentPrice]) AS CurrentPrice, [Amount], [SoldAmount], [IsRecommend], [Memo] FROM [Tickets] WHERE [Amount] > [SoldAmount] AND [DepartDatetime] > GETDATE()");
            if (!string.IsNullOrWhiteSpace(TextBoxDepartCity.Text))
            {
                command.Append(string.Format(" AND [DepartAirport] IN (SELECT [Name] FROM [Airports] WHERE [City] = '{0}')", TextBoxDepartCity.Text));
            }
            if (!string.IsNullOrWhiteSpace(TextBoxArrivalCity.Text))
            {
                command.Append(string.Format(" AND [ArrivalAirport] IN (SELECT [Name] FROM [Airports] WHERE [City] = '{0}')", TextBoxArrivalCity.Text));
            }
            command.Append(string.Format("AND CONVERT(char(8), [DepartDatetime], 112) = '{0}'", CalendarDepartDatetime.SelectedDate.ToString("yyyyMMdd")));
            SqlDataSourceDefaultTickets.SelectCommand = command.ToString();
            //使用新的Select语句执行结果，重新绑定数据
            GridViewTickets.DataBind();
        }

        protected void ButtonShowAll_Click(object sender, EventArgs e)
        {
            //显示所有机票
            SqlDataSourceDefaultTickets.SelectCommand = "SELECT [FlightNumber], [DepartAirport], [ArrivalAirport], [DepartCity], [ArrivalCity], [DepartDatetime], [ArrivalDatetime], [ModelName], CONVERT(numeric(18, 2), [OriginalPrice]) AS OriginalPrice, CONVERT(numeric(18, 2), [CurrentPrice]) AS CurrentPrice, [Amount], [SoldAmount], [IsRecommend], [Memo] FROM [Tickets] WHERE [Amount] > [SoldAmount] AND [DepartDatetime] > GETDATE()";
            //使用新的Select语句执行结果，重新绑定数据
            GridViewTickets.DataBind();
        }

        protected void GridViewRecommendAirports_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Search")
            {
                //检索由推荐城市出发的机票
                int row = Convert.ToInt32(e.CommandArgument);
                string airport = ((Label)GridViewRecommendAirports.Rows[row].Cells[0].FindControl("LabelAirport")).Text;
                SqlDataSourceDefaultTickets.SelectCommand = string.Format("SELECT [FlightNumber], [DepartAirport], [ArrivalAirport], [DepartCity], [ArrivalCity], [DepartDatetime], [ArrivalDatetime], [ModelName], CONVERT(numeric(18, 2), [OriginalPrice]) AS OriginalPrice, CONVERT(numeric(18, 2), [CurrentPrice]) AS CurrentPrice, [Amount], [SoldAmount], [IsRecommend], [Memo] FROM [Tickets] WHERE [Amount] > [SoldAmount] AND [DepartDatetime] > GETDATE() AND [DepartAirport] = '{0}'", airport);
            }
        }

        protected void GridViewRecommendTickets_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Buy")
            {
                //购买推荐机票
                int row = Convert.ToInt32(e.CommandArgument);
                string flightNumber = ((Label)GridViewRecommendTickets.Rows[row].Cells[0].FindControl("LabelFlightNumber")).Text;
                string departDatetime = ((Label)GridViewRecommendTickets.Rows[row].Cells[0].FindControl("LabelDepartDatetime")).Text;
                Response.Redirect(string.Format("BuyTickets.aspx?FlightNumber={0}&DepartDatetime={1}"
                                                , HttpUtility.UrlEncode(flightNumber)
                                                , HttpUtility.UrlEncode(departDatetime)));
            }
        }

        protected void GridViewTickets_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Buy")
            {
                //购买机票
                int row = Convert.ToInt32(e.CommandArgument);
                string flightNumber = ((Label)GridViewTickets.Rows[row].Cells[0].FindControl("LabelFlightNumber")).Text;
                string departDatetime = ((Label)GridViewTickets.Rows[row].Cells[1].FindControl("LabelDepartDatetime")).Text;
                Response.Redirect(string.Format("BuyTickets.aspx?FlightNumber={0}&DepartDatetime={1}"
                                                , HttpUtility.UrlEncode(flightNumber)
                                                , HttpUtility.UrlEncode(departDatetime)));
            }
        }
    }
}