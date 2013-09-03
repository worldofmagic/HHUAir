<%-- 机票管理系统首页，提供到机票管理系统各功能的链接 --%>
<%@ Page Title="机票管理系统 - 纸飞机航空公司" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" ErrorPage="~/Others/Error.aspx"
    CodeBehind="AdminHome.aspx.cs" Inherits="HHUAir.Admin.AdminHome" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <p>
        欢迎进入机票管理系统！请选择需要的服务。
    </p>
    <ul>
        <li><a href="TicketAdmin.aspx" title="">机票管理</a><br />
            管理纸飞机航空公司的所有机票信息。<br />
            设置要在机票销售系统中推荐的热门机票。<br />
            管理所有机票销售订单。<br />
            <span style="color: Red;">注意：在对机票参数进行设置时，机型与机场只能从现有的机型与机场中选择。</span> </li>
        <li><a href="ModelAdmin.aspx" title="">机型管理</a><br />
            管理纸飞机航空公司所有飞机型号及相关资料。 </li>
        <li><a href="AirportAdmin.aspx" title="">机场管理</a><br />
            管理纸飞机航空公司航班涉及的所有机场信息。<br />
            设置要在机票销售系统中推荐的热门机场。 </li>
        <li><a href="../Account/ChangePassword.aspx" title="">修改密码</a><br />
            修改用户登入密码。
        </li>
    </ul>
</asp:Content>
