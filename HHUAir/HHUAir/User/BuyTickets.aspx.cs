using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

namespace HHUAir.User
{
    public partial class BuyTickets : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                //加载机票信息
                string fligntNumber = HttpUtility.UrlDecode(Request.QueryString["FlightNumber"]);
                DateTime departDatetime = DateTime.Parse(HttpUtility.UrlDecode(Request.QueryString["DepartDatetime"]));
                var context = new HHUAirDataContext();
                var ticket = (from c in context.Tickets
                              where c.FlightNumber == fligntNumber && c.DepartDatetime == departDatetime
                              select c).First();
                LabelFlightNumber.Text = ticket.FlightNumber;
                LabelDepartAirport.Text = ticket.DepartAirport;
                LabelDepartCity.Text = ticket.DepartCity;
                LabelDepartDatetime.Text = ticket.DepartDatetime.ToString();
                LabelArrivalAirport.Text = ticket.ArrivalAirport;
                LabelArrivalCity.Text = ticket.ArrivalCity;
                LabelArrivalDatetime.Text = ticket.ArrivalDatetime.ToString();
                var model = (from c in context.Models
                             where c.Name == ticket.ModelName
                             select c).First();
                LabelModelName.Text = model.Name;
                LabelModelType.Text = model.Type;
                LabelMaxSeats.Text = model.MaxSeats.ToString();
                LabelMinSeats.Text = model.MinSeats.ToString();
                LabelCurrentPrice.Text = ticket.CurrentPrice.ToString("0.00");
                LabelOriginalPrice.Text = ticket.OriginalPrice.ToString("0.00");
                LabelDiscount.Text = (ticket.CurrentPrice / ticket.OriginalPrice * 10).ToString("0.0");
                LabelCurrentAmount.Text = (ticket.Amount - ticket.SoldAmount).ToString();
                LabelAmount.Text = ticket.Amount.ToString();
                LabelSoldAmount.Text = ticket.SoldAmount.ToString();
                LabelMemo.Text = string.IsNullOrWhiteSpace(ticket.Memo) ? ticket.Memo : "(无)";
            }
        }

        protected void ButtonConfirmTicketInfo_Click(object sender, EventArgs e)
        {
            LabelCurrentAmountTip.Text = LabelCurrentAmount.Text;
            MultiViewBuy.ActiveViewIndex = 1;
        }

        protected void ButtonAddPassenger_Click(object sender, EventArgs e)
        {
            //增加乘客信息
            if (string.IsNullOrWhiteSpace(TextBoxPassengerName.Text))
            {
                LabelPassengerError.Text = "请填写乘客姓名";
                LabelPassengerError.Visible = true;
                return;
            }
            if (string.IsNullOrWhiteSpace(TextBoxPassengerId.Text))
            {
                LabelPassengerError.Text = "请填写乘客证件号";
                LabelPassengerError.Visible = true;
                return;
            }
            ListBoxPassengers.Items.Add(string.Format("{0} # {1}", TextBoxPassengerName.Text, TextBoxPassengerId.Text));
            TextBoxPassengerName.Text = TextBoxPassengerId.Text = string.Empty;
            LabelPassengerError.Visible = false;
        }

        protected void ButtonClearPassenger_Click(object sender, EventArgs e)
        {
            TextBoxPassengerName.Text = TextBoxPassengerId.Text = string.Empty;
            ListBoxPassengers.Items.Clear();
            LabelPassengerError.Visible = false;
        }

        protected void ButtonConfirmOrderInfo_Click(object sender, EventArgs e)
        {
            //检查订单信息是否合法，若合法则进入下一步
            LabelPassengerError.Visible = false;
            if (string.IsNullOrWhiteSpace(TextBoxAmount.Text))
            {
                LabelOrderError.Text = "请输入订票数";
                LabelOrderError.Visible = true;
                return;
            }
            if (ListBoxPassengers.Items.Count==0)
            {
                LabelOrderError.Text = "请输入乘客信息";
                LabelOrderError.Visible = true;
                return;
            }
            if (string.IsNullOrWhiteSpace(TextBoxContactInfo.Text))
            {
                LabelOrderError.Text = "请输入联系方式";
                LabelOrderError.Visible = true;
                return;
            }
            int amount;
            Int32.TryParse(TextBoxAmount.Text, out amount);
            if (amount == 0 || amount > Int32.Parse(LabelCurrentAmountTip.Text))
            {
                LabelOrderError.Text = "请正确输入订票数";
                LabelOrderError.Visible = true;
                return;
            }
            if (amount != ListBoxPassengers.Items.Count)
            {
                LabelOrderError.Text = "订票数与乘客数不符";
                LabelOrderError.Visible = true;
                return;
            }
            LabelCash.Text = (Double.Parse(LabelCurrentPrice.Text) * amount).ToString("0.00");
            LabelOrderError.Visible = false;
            MultiViewBuy.ActiveViewIndex = 2;
        }

        protected void LinkButtonReturnToTicketInfo_Click(object sender, EventArgs e)
        {
            MultiViewBuy.ActiveViewIndex = 0;
        }

        protected void LinkButtonReturnToOrderInfo_Click(object sender, EventArgs e)
        {
            MultiViewBuy.ActiveViewIndex = 1;
        }

        protected void LinkButtonPayAgain_Click(object sender, EventArgs e)
        {
            MultiViewBuy.ActiveViewIndex = 2;
        }

        protected void ButtonPay_Click(object sender, EventArgs e)
        {
            try
            {
                //购买机票，修改数据库存票数
                StringBuilder passengerNames = new StringBuilder();
                StringBuilder passengerIds = new StringBuilder();
                bool isNotFirst = false;
                foreach (var nameAndId in ListBoxPassengers.Items)
                {
                    if (isNotFirst)
                    {
                        passengerNames.Append(", ");
                        passengerIds.Append(", ");
                    }
                    else
                    {
                        isNotFirst = true;
                    }
                    string[] nai = nameAndId.ToString().Split('#');
                    passengerNames.Append(nai[0]);
                    passengerIds.Append(nai[1]);
                }
                var context = new HHUAirDataContext();
                var order = new Order()
                {
                    Id = Guid.NewGuid(),
                    FlightNumber = LabelFlightNumber.Text,
                    DepartDatetime = DateTime.Parse(LabelDepartDatetime.Text),
                    Amount = Int32.Parse(TextBoxAmount.Text),
                    UserId = (from c in context.aspnet_Users where c.UserName == User.Identity.Name select c.UserId).First(),
                    PassengerNames = passengerNames.ToString(),
                    PassengerIds = passengerIds.ToString(),
                    ContactInfo = TextBoxContactInfo.Text,
                    Memo = TextBoxMemo.Text
                };
                context.Orders.InsertOnSubmit(order);
                var ticket = context.Tickets.SingleOrDefault(c => c.FlightNumber == order.FlightNumber && c.DepartDatetime == order.DepartDatetime);
                ticket.SoldAmount += order.Amount;
                context.SubmitChanges();
                MultiViewBuy.ActiveViewIndex = 4;
            }
            catch
            {
                MultiViewBuy.ActiveViewIndex = 3;
            }
        }
    }
}