<%-- 销售机票的首页，提供机票查找、推荐和浏览功能 --%>
<%@ Page Title="购买机票 - 纸飞机航空公司" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" ErrorPage="~/Others/Error.aspx"
    CodeBehind="TicketCenter.aspx.cs" Inherits="HHUAir.User.TicketCenter" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <%-- 数据源控件，提供对Tickets数据表中未过期且未售完的机票的检索，以便在列表中列出所有可售机票 --%>
    <asp:SqlDataSource ID="SqlDataSourceDefaultTickets" runat="server" 
        ConnectionString="<%$ ConnectionStrings:HHUAirDBConnectionString %>" 
        SelectCommand="SELECT [FlightNumber], [DepartAirport], [ArrivalAirport], [DepartCity], [ArrivalCity], [DepartDatetime], [ArrivalDatetime], [ModelName], CONVERT(numeric(18, 2), [OriginalPrice]) AS OriginalPrice, CONVERT(numeric(18, 2), [CurrentPrice]) AS CurrentPrice, [Amount], [SoldAmount], [IsRecommend], [Memo] FROM [Tickets] WHERE [Amount] > [SoldAmount] AND [DepartDatetime] > GETDATE()"></asp:SqlDataSource>
    <%-- 数据源控件，提供对Airports数据表中IsRecommend字段值为1的记录，以便列出所有推荐的热门机场 --%>
    <asp:SqlDataSource ID="SqlDataSourceRecommendAirports" runat="server" 
        ConnectionString="<%$ ConnectionStrings:HHUAirDBConnectionString %>" 
        SelectCommand="SELECT * FROM [Airports] WHERE IsRecommend=1"></asp:SqlDataSource>
    <%-- 数据源控件，提供对Tickets数据表中IsRecommend字段值为1的记录，以便列出所有推荐的热门机票 --%>
    <asp:SqlDataSource ID="SqlDataSourceRecommendTickets" runat="server" 
        ConnectionString="<%$ ConnectionStrings:HHUAirDBConnectionString %>" 
        SelectCommand="SELECT [FlightNumber], [DepartCity], [ArrivalCity], [DepartDatetime], [IsRecommend], CONVERT(numeric(18, 2), [CurrentPrice]) AS CurrentPrice, [Amount], [SoldAmount] FROM [Tickets]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourceDefaultCities" runat="server" 
        ConnectionString="<%$ ConnectionStrings:HHUAirDBConnectionString %>" 
        SelectCommand="SELECT DISTINCT [City] FROM [Airports]"></asp:SqlDataSource>
    <table align="center">
        <tr>
            <%-- 提供按出发城市、抵达城市和出发时间检索机票的功能 --%>
            <td align="center" style="background-color: #F7F6F3;">
                出发城市<br />
                <asp:TextBox ID="TextBoxDepartCity" runat="server" Width="200px"></asp:TextBox>
                <br />
                <%-- 将选择城市下拉列表内容与数据库中的有关记录绑定 --%>
                (选择城市: 
                <asp:DropDownList ID="DropDownListDepartCities" runat="server" 
                    AutoPostBack="True" DataSourceID="SqlDataSourceDefaultCities" 
                    DataTextField="City" DataValueField="City" 
                    onselectedindexchanged="DropDownListDepartCities_SelectedIndexChanged">
                </asp:DropDownList>
                )<br />
               抵达城市<br />
                <asp:TextBox ID="TextBoxArrivalCity" runat="server" Width="200px"></asp:TextBox>
                <br />
                <%-- 将选择城市下拉列表内容与数据库中的有关记录绑定 --%>
                (选择城市: 
                <asp:DropDownList ID="DropDownListArrivalCities" runat="server" 
                    AutoPostBack="True" DataSourceID="SqlDataSourceDefaultCities" 
                    DataTextField="City" DataValueField="City" 
                    onselectedindexchanged="DropDownListArrivalCities_SelectedIndexChanged">
                </asp:DropDownList>
                )<asp:Calendar ID="CalendarDepartDatetime" runat="server" BackColor="White" 
                    BorderColor="#999999" Caption="出发日期" CellPadding="4" DayNameFormat="Shortest" 
                    Font-Names="Verdana" Font-Size="8pt" ForeColor="Black" Height="180px" 
                    Width="200px">
                    <DayHeaderStyle BackColor="#CCCCCC" Font-Bold="True" Font-Size="7pt" />
                    <NextPrevStyle VerticalAlign="Bottom" />
                    <OtherMonthDayStyle ForeColor="#808080" />
                    <SelectedDayStyle BackColor="#666666" Font-Bold="True" ForeColor="White" />
                    <SelectorStyle BackColor="#CCCCCC" />
                    <TitleStyle BackColor="#999999" BorderColor="Black" Font-Bold="True" />
                    <TodayDayStyle BackColor="#CCCCCC" ForeColor="Black" />
                    <WeekendDayStyle BackColor="#FFFFCC" />
                </asp:Calendar>
                <%-- 检索符合条件的机票，由后台事件响应代码实现 --%>
                <asp:Button ID="ButtonFilter" runat="server" ForeColor="Red" Text="筛选在售机票" 
                    Width="100px" onclick="ButtonFilter_Click" />
                <asp:Button ID="ButtonShowAll" runat="server" ForeColor="Lime" Text="显示全部机票" 
                    Width="100px" onclick="ButtonShowAll_Click" />
            </td>
            <%-- 提供热门机场推荐 --%>
            <td align="center" style="background-color: #F7F6F3;">
                <%-- 显示热门机场，通过将各控件绑定到数据表各字段实现 --%>
                <asp:GridView ID="GridViewRecommendAirports" runat="server" 
                    AutoGenerateColumns="False" CellPadding="4" DataKeyNames="Name,City" 
                    DataSourceID="SqlDataSourceRecommendAirports" ForeColor="#333333" 
                    GridLines="None" style="text-align: center" Width="252px" Caption="热门机场推荐" 
                    AllowPaging="True" ShowHeader="False" 
                    onrowcommand="GridViewRecommendAirports_RowCommand">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField>
                            <EditItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="LabelAirport" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                                &nbsp;(<asp:Label ID="LabelCity" runat="server" Text='<%# Bind("City") %>'></asp:Label>
                                )
                            </ItemTemplate>
                            <HeaderStyle Width="250px" />
                            <ItemStyle Width="250px" />
                        </asp:TemplateField>
                        <%-- 检索由该热门机场出发的机票，由后台事件响应代码实现 --%>
                        <asp:ButtonField Text="查找" CommandName="Search">
                        <HeaderStyle Width="50px" />
                        <ItemStyle Width="50px" />
                        </asp:ButtonField>
                    </Columns>
                    <EditRowStyle BackColor="#7C6F57" />
                    <EmptyDataTemplate>
                        暂无推荐机场
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#666666" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#E3EAEB" />
                    <SelectedRowStyle BackColor="#C5BBAF" Font-Bold="True" ForeColor="#333333" />
                    <SortedAscendingCellStyle BackColor="#F8FAFA" />
                    <SortedAscendingHeaderStyle BackColor="#246B61" />
                    <SortedDescendingCellStyle BackColor="#D4DFE1" />
                    <SortedDescendingHeaderStyle BackColor="#15524A" />
                </asp:GridView>
            </td>
            <%-- 提供热门机票推荐 --%>
            <td align="center" style="background-color: #F7F6F3;">
                <%-- 显示热门机票，通过将各控件绑定到数据表各字段实现 --%>
                <asp:GridView ID="GridViewRecommendTickets" runat="server" 
                    AutoGenerateColumns="False" CellPadding="4" DataKeyNames="FlightNumber,DepartDatetime" 
                    DataSourceID="SqlDataSourceRecommendTickets" ForeColor="#333333" 
                    GridLines="None" style="text-align: center" Width="252px" Caption="热门机票推荐" 
                    AllowPaging="True" PageSize="5" ShowHeader="False" 
                    onrowcommand="GridViewRecommendTickets_RowCommand">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField>
                            <EditItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="LabelFlightNumber" runat="server" 
                                    Text='<%# Bind("FlightNumber") %>' Visible="False"></asp:Label>
                                <asp:Label ID="LabelDepartCity" runat="server" 
                                    Text='<%# Bind("DepartCity") %>'></asp:Label>
                                &nbsp;- 
                                <asp:Label ID="LabelArrivalCity" runat="server" 
                                    Text='<%# Bind("ArrivalCity") %>'></asp:Label>
                                <br />
                                <asp:Label ID="LabelDepartDatetime" runat="server" 
                                    Text='<%# Bind("DepartDatetime") %>'></asp:Label>
                                <br />
                                <span class="style1">只需<asp:Label ID="LabelCityCurrentPrice" runat="server" 
                                    Text='<%# Bind("CurrentPrice") %>' ForeColor="Red"></asp:Label>
                                元</span>
                            </ItemTemplate>
                            <HeaderStyle Width="250px" />
                            <ItemStyle Width="250px" />
                        </asp:TemplateField>
                        <%-- 购买该热门机票，由后台事件响应代码实现 --%>
                        <asp:ButtonField Text="购买" CommandName="Buy">
                        <HeaderStyle Width="50px" />
                        <ItemStyle Width="50px" />
                        </asp:ButtonField>
                    </Columns>
                    <EditRowStyle BackColor="#7C6F57" />
                    <EmptyDataTemplate>
                        暂无推荐机票
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#666666" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#E3EAEB" />
                    <SelectedRowStyle BackColor="#C5BBAF" Font-Bold="True" ForeColor="#333333" />
                    <SortedAscendingCellStyle BackColor="#F8FAFA" />
                    <SortedAscendingHeaderStyle BackColor="#246B61" />
                    <SortedDescendingCellStyle BackColor="#D4DFE1" />
                    <SortedDescendingHeaderStyle BackColor="#15524A" />
                </asp:GridView>
            </td>
        </tr>
        <tr>
            <td align="center" colspan="3">
            <%-- 显示现有机票，或条件检索结果，通过将各控件绑定到数据表各字段实现 --%>
            <asp:GridView DataKeyNames="FlightNumber,DepartDatetime" ID="GridViewTickets" runat="server"
                    DataSourceID="SqlDataSourceDefaultTickets" AllowPaging="True" AllowSorting="True" 
                    AutoGenerateColumns="False" Caption="在售机票"
                    CellPadding="4" ForeColor="#333333" GridLines="None" 
                    Style="text-align: center" onrowcommand="GridViewTickets_RowCommand">
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                    <Columns>
                        <asp:TemplateField HeaderText="航班号" SortExpression="FlightNumber">
                            <ItemTemplate>
                                <asp:Label ID="LabelFlightNumber" runat="server" Text='<%# Bind("FlightNumber") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle Width="50px" />
                            <ItemStyle Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="起点" 
                            SortExpression="DepartDatetime,DepartCity,DepartAirport">
                            <ItemTemplate>
                                <asp:Label ID="LabelDepartAirport" runat="server" Text='<%# Bind("DepartAirport") %>'></asp:Label>
                                &nbsp;(<asp:Label ID="LabelDepartCity" runat="server" Text='<%# Bind("DepartCity") %>'></asp:Label>)<br />
                                出发时间:
                                <asp:Label ID="LabelDepartDatetime" runat="server" Text='<%# Bind("DepartDatetime") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle Width="200px" />
                            <ItemStyle Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="终点" 
                            SortExpression="ArrivalDatetime,ArrivalCity,ArrivalAirport">
                            <ItemTemplate>
                                <asp:Label ID="LabelArrivalAirport" runat="server" Text='<%# Bind("ArrivalAirport") %>'></asp:Label>
                                &nbsp;(<asp:Label ID="LabelArrivalCity" runat="server" Text='<%# Bind("ArrivalCity") %>'></asp:Label>)<br />
                                抵达时间:
                                <asp:Label ID="LabelArrivalDatetime" runat="server" Text='<%# Bind("ArrivalDatetime") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle Width="200px" />
                            <ItemStyle Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="机型" SortExpression="ModelName">
                            <ItemTemplate>
                                <asp:Label ID="LabelModelName" runat="server" Text='<%# Bind("ModelName") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle Width="50px" />
                            <ItemStyle Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="机票信息" 
                            SortExpression="CurrentPrice,OriginalPrice,Amount,SoldAmount">
                            <ItemTemplate>
                                原价:
                                <asp:Label ID="LabelOriginalPrice" runat="server" Text='<%# Bind("OriginalPrice") %>'></asp:Label>
                                元<br />现价:
                                <asp:Label ID="LabelCurrentPrice" runat="server" 
                                    Text='<%# Bind("CurrentPrice") %>' ForeColor="Red"></asp:Label>
                                元<br />票数:
                                <asp:Label ID="LabelAmount" runat="server" Text='<%# Bind("Amount") %>'></asp:Label>
                                张<br />售出:
                                <asp:Label ID="LabelSoldAmount" runat="server" Text='<%# Bind("SoldAmount") %>'></asp:Label>
                                张
                            </ItemTemplate>
                            <HeaderStyle Width="100px" />
                            <ItemStyle Width="100px" />
                        </asp:TemplateField>
                        <asp:CheckBoxField DataField="IsRecommend" HeaderText="推荐" Text="IsRecommend">
                            <HeaderStyle Width="50px" Wrap="False" />
                            <ItemStyle Width="50px" />
                        </asp:CheckBoxField>
                        <asp:TemplateField HeaderText="备注" SortExpression="Memo">
                            <ItemTemplate>
                                <asp:Label ID="LabelMemo" runat="server" Text='<%# Bind("Memo") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle Width="100px" />
                            <ItemStyle Width="100px" />
                        </asp:TemplateField>
                        <%-- 购买该机票，由后台事件响应代码实现 --%>
                        <asp:ButtonField Text="购买" CommandName="Buy">
                        <HeaderStyle Width="50px" />
                        <ItemStyle Width="50px" />
                        </asp:ButtonField>
                    </Columns>
                    <EditRowStyle BackColor="#999999" />
                    <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                    <SortedAscendingCellStyle BackColor="#E9E7E2" />
                    <SortedAscendingHeaderStyle BackColor="#506C8C" />
                    <SortedDescendingCellStyle BackColor="#FFFDF8" />
                    <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                    <EmptyDataTemplate>
                        暂无在售机票
                    </EmptyDataTemplate>
                </asp:GridView>
            </td>
        </tr>
        <tr>
        <td colspan="3" align="center">
            <a href="UserHome.aspx" title="">返回机票销售系统首页</a></td>
        </tr>
    </table>
</asp:Content>
