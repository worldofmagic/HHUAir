<%-- 机票销售系统首页，提供到机票销售系统各功能的链接 --%>
<%@ Page Title="机票销售系统 - 纸飞机航空公司" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" ErrorPage="~/Others/Error.aspx"
    CodeBehind="UserHome.aspx.cs" Inherits="HHUAir.User.UserHome" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <p>
        欢迎进入机票销售系统！请选择需要的服务。</p>
    <ul>
        <li><a href="TicketCenter.aspx" title="">购买机票</a><br />
            浏览纸飞机航空公司的热门机票和机场推荐。<br />
            浏览、查纸飞机航空公司的找在售机票。<br />
            下单购买机票。</li>
        <li><a href="OrderCenter.aspx" title="">管理订单</a><br />
            查看您的所有机票购买订单记录。</li>
        <li><a href="../Account/ChangePassword.aspx" title="">修改密码</a><br />
            修改用户登入密码。
        </li>
    </ul>
</asp:Content>
