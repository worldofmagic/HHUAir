<%-- 购票流程页面 --%>
<%@ Page Title="新订单 - 购买机票 - 纸飞机航空公司" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" ErrorPage="~/Others/Error.aspx"
    CodeBehind="BuyTickets.aspx.cs" Inherits="HHUAir.User.BuyTickets" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:MultiView ID="MultiViewBuy" runat="server" ActiveViewIndex="0">
        <%-- 第一步，核对机票信息 --%>
        <asp:View ID="ViewTicketInfo" runat="server">
            <p>
                <span style="color: Red;">请认真核对您即将购买的机票信息！</span>
            </p>
            <ul>
                <li>航班号:
                    <asp:Label ID="LabelFlightNumber" runat="server" Text="[未知]"></asp:Label>
                </li>
                <li>出发机场和时间:
                    <asp:Label ID="LabelDepartAirport" runat="server" Text="[未知]"></asp:Label>
                    &nbsp;(<asp:Label ID="LabelDepartCity" runat="server" Text="[未知]"></asp:Label>
                    )
                    <asp:Label ID="LabelDepartDatetime" runat="server" Text="[未知]"></asp:Label>
                </li>
                <li>抵达机场和时间:
                    <asp:Label ID="LabelArrivalAirport" runat="server" Text="[未知]"></asp:Label>
                    &nbsp;(<asp:Label ID="LabelArrivalCity" runat="server" Text="[未知]"></asp:Label>
                    )
                    <asp:Label ID="LabelArrivalDatetime" runat="server" Text="[未知]"></asp:Label>
                </li>
                <li>机型:
                    <asp:Label ID="LabelModelName" runat="server" Text="[未知]"></asp:Label>
                    &nbsp;(类型:
                    <asp:Label ID="LabelModelType" runat="server" Text="[未知]"></asp:Label>
                    &nbsp;最多座位数:
                    <asp:Label ID="LabelMaxSeats" runat="server" Text="[未知]"></asp:Label>
                    &nbsp;最少座位数:
                    <asp:Label ID="LabelMinSeats" runat="server" Text="[未知]"></asp:Label>
                    )</li>
                <li>当前票价:
                    <asp:Label ID="LabelCurrentPrice" runat="server" ForeColor="Red" Text="[未知]"></asp:Label>
                    元&nbsp;(原价:
                    <asp:Label ID="LabelOriginalPrice" runat="server" Text="[未知]"></asp:Label>
                    元 折扣:
                    <asp:Label ID="LabelDiscount" runat="server" ForeColor="Red" Text="[未知]"></asp:Label>
                    折)</li>
                <li>剩余票数:
                    <asp:Label ID="LabelCurrentAmount" runat="server" Text="[未知]"></asp:Label>
                    张 (总数:
                    <asp:Label ID="LabelAmount" runat="server" Text="[未知]"></asp:Label>
                    张 售出:
                    <asp:Label ID="LabelSoldAmount" runat="server" Text="[未知]"></asp:Label>
                    张)</li>
                <li>备注:
                    <asp:Label ID="LabelMemo" runat="server" Text="[未知]"></asp:Label>
                </li>
            </ul>
            <p>
                <asp:Button ID="ButtonConfirmTicketInfo" runat="server" ForeColor="#009900" 
                    Text="核对无误，继续购买" onclick="ButtonConfirmTicketInfo_Click" />
                &nbsp;<a href="TicketCenter.aspx" title="">返回重新选择机票</a>
            </p>
        </asp:View>
        <%-- 第二步，填写订单信息 --%>
        <asp:View ID="ViewOrderInfo" runat="server">
            请填写订单信息！<br /> 
            <asp:Label ID="LabelOrderError" runat="server" ForeColor="Red" Text="[ERROR]" 
                Visible="False"></asp:Label>
            &nbsp;<ul>
                <li>
                    <p>
                        订票数:
                        <asp:TextBox ID="TextBoxAmount" runat="server"></asp:TextBox>
                        张&nbsp;(剩余票数:
                        <asp:Label ID="LabelCurrentAmountTip" runat="server" Text="[未知]"></asp:Label>
                        )</p>
                </li>
                <li>
                    <p>
                        乘客信息 (每张票对应一名乘客)<br /> 
                        <asp:ListBox ID="ListBoxPassengers" runat="server" Width="280px"></asp:ListBox>
                        <br />
                        新增乘客信息 
                        <asp:Label ID="LabelPassengerError" runat="server" ForeColor="Red" 
                            Text="[ERROR]" Visible="False"></asp:Label>
                        <br />
                        姓　名:
                        <asp:TextBox ID="TextBoxPassengerName" runat="server"></asp:TextBox>
                        <br />
                        证件号:
                        <asp:TextBox ID="TextBoxPassengerId" runat="server"></asp:TextBox>
                        <br />
                        <asp:Button ID="ButtonAddPassenger" runat="server" 
                            onclick="ButtonAddPassenger_Click" Text="增加" />
                        &nbsp;<asp:Button ID="ButtonClearPassenger" runat="server" 
                            onclick="ButtonClearPassenger_Click" Text="重填" />
                    </p>
                </li>
                <li>
                    <p>
                        联系方式:
                        <asp:TextBox ID="TextBoxContactInfo" runat="server" Height="40px" 
                            TextMode="MultiLine" Width="220px"></asp:TextBox>
                    </p>
                </li>
                <li>
                    <p>
                        备　　注:
                        <asp:TextBox ID="TextBoxMemo" runat="server" Height="40px" TextMode="MultiLine" 
                            Width="220px"></asp:TextBox>
                    </p>
                </li>
            </ul>
            <p>
                <asp:Button ID="ButtonConfirmOrderInfo" runat="server" ForeColor="#009900" 
                    onclick="ButtonConfirmOrderInfo_Click" Text="填写无误，继续购买" />
                &nbsp;<asp:LinkButton ID="LinkButtonReturnToTicketInfo" runat="server" 
                    onclick="LinkButtonReturnToTicketInfo_Click">返回确认机票信息</asp:LinkButton>
            </p>
        </asp:View>
        <%-- 第三步，确认付款金额并支付（模拟支付） --%>
        <asp:View ID="ViewPay" runat="server">
            <p>请付款！</p>
            <p style="text-align:center;">
                您共需支付<br /> 
                <asp:Label ID="LabelCash" runat="server" Font-Bold="True" Font-Size="XX-Large" 
                    ForeColor="#009900" Text="[未知]"></asp:Label>
                元</p>
            <p style="text-align:center;">
                <asp:Button ID="ButtonPay" runat="server" ForeColor="#009900" 
                    onclick="ButtonPay_Click" Text="立即支付" />
                &nbsp;<asp:LinkButton ID="LinkButtonReturnToOrderInfo" runat="server" 
                    onclick="LinkButtonReturnToOrderInfo_Click">返回修改订单信息</asp:LinkButton>
            </p>
        </asp:View>
        <%-- 第四步，若发生错误则提示订票失败，否则提示订票成功 --%>
        <asp:View ID="ViewFailed" runat="server">
            很抱歉，订票失败！<br /> 请尝试<asp:LinkButton ID="LinkButtonPayAgain" runat="server" 
                onclick="LinkButtonPayAgain_Click">重新支付</asp:LinkButton>
            ，或<asp:LinkButton ID="LinkButtonCheckOrderInfo" runat="server" 
                onclick="LinkButtonReturnToOrderInfo_Click">再次检查订单信息</asp:LinkButton>
            。
        </asp:View>
        <asp:View ID="ViewSucceed" runat="server">
            <p>恭喜，订票成功！现在您可以：</p>
            <ul>
                <li>
                    <p>
                        <a href="TicketCenter.aspx" title="">继续购买其它机票。</a></p>
                </li>
                <li>
                    <p>
                        <a href="OrderCenter.aspx" title="">管理我的订单。</a></p>
                </li>
            </ul>
        </asp:View>
    </asp:MultiView>
</asp:Content>
