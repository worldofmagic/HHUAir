﻿<%-- 订单管理页面 --%>
<%@ Page Title="订单管理 - 纸飞机航空公司" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" ErrorPage="~/Others/Error.aspx"
    CodeBehind="OrderAdmin.aspx.cs" Inherits="HHUAir.Admin.OrderAdmin" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <%-- 数据源控件，提供对Orders数据表的检索和删除支持 --%>
    <asp:SqlDataSource ID="SqlDataSourceOrders" runat="server" ConnectionString="<%$ ConnectionStrings:HHUAirDBConnectionString %>"
        SelectCommand="SELECT * FROM [Orders]" DeleteCommand="DELETE FROM [Orders] WHERE Id = @original_Id"
        OldValuesParameterFormatString="original_{0}"></asp:SqlDataSource>
    <p>
        欢迎进入订单管理！
    </p>
    <p>
        您可以在此管理纸飞机航空公司的所有机票销售订单，或者<a href="TicketAdmin.aspx" title="">返回机票管理页面</a>。
    </p>
    <p>
        注意事项：</p>
    <ul>
        <li>机票销售订单只能查看或者删除（撤销订单），不能修改。</li>
        <li>要新增机票销售订单，请<a href="../User/UserHome.aspx" title="">进入机票销售系统</a>购买机票。</li>
    </ul>
    <table align="center">
        <tr>
            <td align="center">
                <%-- 显示现有订单，并提供删除记录的功能，通过将各控件绑定到数据表各字段实现 --%>
                <asp:GridView ID="GridViewOrders" runat="server" CellPadding="4" ForeColor="#333333"
                    GridLines="None" DataSourceID="SqlDataSourceOrders" AllowPaging="True" AllowSorting="True"
                    AutoGenerateColumns="False" AutoGenerateDeleteButton="True" Caption="现有订单" DataKeyNames="Id">
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="订单号" SortExpression="Id">
                            <HeaderStyle Width="100px" />
                            <ItemStyle Width="100px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="FlightNumber" HeaderText="航班号" 
                            SortExpression="FlightNumber">
                            <HeaderStyle Width="100px" />
                            <ItemStyle Width="100px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="DepartDatetime" HeaderText="出发时间" 
                            SortExpression="DepartDatetime">
                            <HeaderStyle Width="100px" />
                            <ItemStyle Width="100px" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="票数" DataField="Amount" SortExpression="Amount">
                            <HeaderStyle Width="100px" />
                            <ItemStyle Width="100px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="PassengerNames" HeaderText="乘客姓名" 
                            SortExpression="PassengerNames">
                        <HeaderStyle Width="100px" />
                        <ItemStyle Width="100px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="PassengerIds" HeaderText="乘客证件号" 
                            SortExpression="PassengerIds">
                        <HeaderStyle Width="100px" />
                        <ItemStyle Width="100px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="ContactInfo" HeaderText="乘客联系方式" 
                            SortExpression="ContactInfo">
                        <HeaderStyle Width="100px" />
                        <ItemStyle Width="100px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Memo" HeaderText="备注" SortExpression="Memo">
                            <HeaderStyle Width="200px" />
                            <ItemStyle Width="200px" />
                        </asp:BoundField>
                    </Columns>
                    <EditRowStyle BackColor="#999999" />
                    <EmptyDataTemplate>
                        尚无任何订单
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                    <SortedAscendingCellStyle BackColor="#E9E7E2" />
                    <SortedAscendingHeaderStyle BackColor="#506C8C" />
                    <SortedDescendingCellStyle BackColor="#FFFDF8" />
                    <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                </asp:GridView>
            </td>
        </tr>
    </table>
</asp:Content>