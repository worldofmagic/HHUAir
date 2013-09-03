<%-- 首页 --%>
<%@ Page Title="纸飞机航空公司" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" ErrorPage="~/Others/Error.aspx"
    CodeBehind="Default.aspx.cs" Inherits="HHUAir.Default" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <p>
        欢迎莅临纸飞机航空公司！请选择需要的服务。
    </p>
    <table align="center">
        <tr>
            <td style="text-align: center; width: 400px">
                <asp:ImageButton ID="ImageButtonUser" runat="server" ImageUrl="~/Images/UserIcon.png"
                    ToolTip="进入机票销售系统" PostBackUrl="~/User/UserHome.aspx" />
            </td>
            <td style="text-align: center; width: 400px">
                <asp:ImageButton ID="ImageButtonAdmin" runat="server" ImageUrl="~/Images/AdminIcon.png"
                    ToolTip="进入机票管理系统" PostBackUrl="~/Admin/AdminHome.aspx" />
            </td>
        </tr>
        <tr>
            <td style="text-align: center; width: 400px">
                查询航班时刻表、机票余量和折扣信息，在线订票
            </td>
            <td style="text-align: center; width: 400px">
                录入并管理航班和机票信息（<span style="color: red;">需要以管理员身份登录</span>）
            </td>
        </tr>
    </table>
</asp:Content>
