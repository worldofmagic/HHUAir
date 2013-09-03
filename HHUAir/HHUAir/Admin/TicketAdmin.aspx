<%-- 机票管理页面 --%>
<%@ Page Title="机票管理 - 纸飞机航空公司" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" ErrorPage="~/Others/Error.aspx"
    CodeBehind="TicketAdmin.aspx.cs" Inherits="HHUAir.Admin.TicketAdmin" ErrorPage="~/Error.aspx" %>
<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
    </style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <%-- 数据源控件，提供对Tickets数据表的检索和删除支持 --%>
    <asp:SqlDataSource ID="SqlDataSourceTickets" runat="server" ConnectionString="<%$ ConnectionStrings:ApplicationServices %>"
        SelectCommand="SELECT [FlightNumber], [DepartAirport], [ArrivalAirport], [DepartCity], [ArrivalCity], [DepartDatetime], [ArrivalDatetime], [ModelName], CONVERT(numeric(18, 2), [OriginalPrice]) AS OriginalPrice, CONVERT(numeric(18, 2), [CurrentPrice]) AS CurrentPrice, [Amount], [SoldAmount], [IsRecommend], [Memo] FROM [Tickets]"
        UpdateCommand="UPDATE [Tickets]
                       SET FlightNumber = @FlightNumber, 
                           DepartAirport = @DepartAirport, ArrivalAirport = @ArrivalAirport,
                           DepartCity = @DepartCity, ArrivalCity = @ArrivalCity,
                           DepartDatetime = @DepartDatetime, ArrivalDatetime = @ArrivalDatetime,
                           ModelName = @ModelName,
                           OriginalPrice = @OriginalPrice, CurrentPrice = @CurrentPrice,
                           Amount = @Amount, SoldAmount = @SoldAmount,
                           IsRecommend = @IsRecommend,
                           Memo = @Memo
                       WHERE FlightNumber = @original_FlightNumber AND DepartDatetime = @original_DepartDatetime"
        DeleteCommand="DELETE FROM [Tickets] WHERE FlightNumber = @original_FlightNumber AND DepartDatetime = @original_DepartDatetime"
        InsertCommand="INSERT INTO [Tickets](FlightNumber, DepartAirport, ArrivalAirport, DepartCity, ArrivalCity, DepartDatetime, ArrivalDatetime, ModelName, OriginalPrice, CurrentPrice, Amount, SoldAmount, IsRecommend, Memo)
                       VALUES (@FlightNumber, @DepartAirport, @ArrivalAirport, @DepartCity, @ArrivalCity, @DepartDatetime, @ArrivalDatetime, @ModelName, @OriginalPrice, @CurrentPrice, @Amount, @SoldAmount, @IsRecommend, @Memo)"
        OldValuesParameterFormatString="original_{0}"></asp:SqlDataSource>
    <%-- 数据源控件，提供对Airports数据表中City字段的检索，以便在录入数据时可在现有城市名称中进行选择 --%>
    <asp:SqlDataSource ID="SqlDataSourceCities" runat="server" ConnectionString="<%$ ConnectionStrings:ApplicationServices %>"
        SelectCommand="SELECT DISTINCT [City] FROM [Airports]"></asp:SqlDataSource>
    <%-- 数据源控件，提供对Models数据表中Name字段的检索，以便在录入数据时可在现有机型名称中进行选择 --%>
    <asp:SqlDataSource ID="SqlDataSourceModels" runat="server" ConnectionString="<%$ ConnectionStrings:ApplicationServices %>"
        SelectCommand="SELECT DISTINCT [Name] FROM [Models]"></asp:SqlDataSource>
    <%-- 数据源控件，提供对Airports数据表中Name字段的检索，以便在录入数据时可在现有机场名称中进行选择 --%>
    <asp:SqlDataSource ID="SqlDataSourceAirports" runat="server" ConnectionString="<%$ ConnectionStrings:ApplicationServices %>"
        SelectCommand="SELECT DISTINCT [Name] FROM [Airports]"></asp:SqlDataSource>
    <asp:ScriptManager ID="ScriptManagerPresentation" runat="server">
    </asp:ScriptManager>
    <p>
        欢迎进入机型管理！
    </p>
    <p>
        您可以在此管理纸飞机航空公司的所有机票信息，或者<a href="AdminHome.aspx" title="">返回机票管理系统首页</a>。
    </p>
    <p>
        注意事项：</p>
    <ul>
        <li>相同航班号和出发时间的机票不能重复添加。</li>
        <li><span class="style1">设定的售出票数必须大于等于实际售出票数，已有订单的机票不能随意删改，您可以</span><a href="OrderAdmin.aspx" title="">在此管理机票销售订单</a>。</li>
        <li>机型与机场只能从现有的机型与机场中选择，您可以<a href="ModelAdmin.aspx" title="">在此管理现有机型</a>，或者<a 
                href="AirportAdmin.aspx">在此管理现有机场</a>。</li>
    </ul>
    <p>
        <asp:Label ID="LabelErrorMessage" runat="server" ForeColor="Red" Text="[ERROR]" 
            Visible="False"></asp:Label>
    </p>
    <table align="center">
        <tr>
            <td style="background-color: #F7F6F3;">
                <%-- 增加机票，通过将各控件绑定到数据表各字段实现 --%>
                <asp:DetailsView ID="DetailsViewNewTicket" runat="server" Height="50px" Width="900px"
                    AllowPaging="True" AutoGenerateInsertButton="True" 
                    AutoGenerateRows="False" Caption="添加新机票"
                    CellPadding="4" DataSourceID="SqlDataSourceTickets" DefaultMode="Insert" ForeColor="#333333"
                    GridLines="None" onitemcommand="DetailsViewNewTicket_ItemCommand" 
                    oniteminserting="DetailsViewNewTicket_ItemInserting">
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                    <CommandRowStyle BackColor="#E2DED6" Font-Bold="True" />
                    <EditRowStyle BackColor="#999999" />
                    <FieldHeaderStyle BackColor="#F7F6F3" Font-Bold="True" />
                    <Fields>
                        <asp:TemplateField HeaderText="航班号">
                            <InsertItemTemplate>
                                <asp:TextBox ID="TextBoxFlightNumber" runat="server" Text='<%# Bind("FlightNumber") %>'
                                    Width="150px"></asp:TextBox>
                                &nbsp;(航班号格式为10位字母或数字)
                            </InsertItemTemplate>
                            <HeaderStyle Width="70px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="起点">
                            <InsertItemTemplate>
                                出发城市:
                                <asp:DropDownList ID="DropDownListDepartCity" runat="server" AutoPostBack="True"
                                    DataSourceID="SqlDataSourceCities" DataTextField="City" DataValueField="City"
                                    OnSelectedIndexChanged="DropDownListDepartCity_New_SelectedIndexChanged" SelectedValue='<%# Bind("DepartCity") %>'
                                    Width="200px">
                                </asp:DropDownList>
                                &nbsp;出发机场:
                                <asp:DropDownList ID="DropDownListDepartAirport" runat="server" DataSourceID="SqlDataSourceAirports"
                                    DataTextField="Name" DataValueField="Name" OnPreRender="DropDownListDepartAirport_New_PreRender"
                                    SelectedValue='<%# Bind("DepartAirport") %>' Width="200px">
                                </asp:DropDownList>
                                &nbsp;出发时间:
                                <asp:TextBox ID="TextBoxDepartDatetime" runat="server" Text='<%# Bind("DepartDatetime") %>'
                                    Width="200px"></asp:TextBox>
                            </InsertItemTemplate>
                            <HeaderStyle Width="70px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="终点">
                            <InsertItemTemplate>
                                抵达城市:
                                <asp:DropDownList ID="DropDownListArrivalCity" runat="server" AutoPostBack="True"
                                    DataSourceID="SqlDataSourceCities" DataTextField="City" DataValueField="City"
                                    OnSelectedIndexChanged="DropDownListArrivalCity_New_SelectedIndexChanged" SelectedValue='<%# Bind("ArrivalCity") %>'
                                    Width="200px">
                                </asp:DropDownList>
                                &nbsp;抵达机场:
                                <asp:DropDownList ID="DropDownListArrivalAirport" runat="server" DataSourceID="SqlDataSourceAirports"
                                    DataTextField="Name" DataValueField="Name" OnPreRender="DropDownListArrivalAirport_New_PreRender"
                                    SelectedValue='<%# Bind("ArrivalAirport") %>' Width="200px">
                                </asp:DropDownList>
                                &nbsp;抵达时间:
                                <asp:TextBox ID="TextBoxArrivalDatetime" runat="server" Text='<%# Bind("ArrivalDatetime") %>'
                                    Width="200px"></asp:TextBox>
                            </InsertItemTemplate>
                            <HeaderStyle Width="70px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="机型">
                            <InsertItemTemplate>
                                <asp:DropDownList ID="DropDownListModelName" runat="server" DataSourceID="SqlDataSourceModels"
                                    DataTextField="Name" DataValueField="Name" SelectedValue='<%# Bind("ModelName") %>'
                                    Width="150px">
                                </asp:DropDownList>
                            </InsertItemTemplate>
                            <HeaderStyle Width="70px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="机票信息">
                            <InsertItemTemplate>
                                原始票价:
                                <asp:TextBox ID="TextBoxOriginalPrice" runat="server" Text='<%# Bind("OriginalPrice") %>'
                                    Width="100px"></asp:TextBox>
                                元&nbsp;当前票价:
                                <asp:TextBox ID="TextBoxCurrentPrice" runat="server" Text='<%# Bind("CurrentPrice") %>'
                                    Width="100px"></asp:TextBox>
                                元&nbsp;合计票数:
                                <asp:TextBox ID="TextBoxAmount" runat="server" Text='<%# Bind("Amount") %>' Width="100px"></asp:TextBox>
                                张&nbsp;售出票数:
                                <asp:TextBox ID="TextBoxSoldAmount" runat="server" Text='<%# Bind("SoldAmount") %>'
                                    Width="100px"></asp:TextBox>
                                张
                            </InsertItemTemplate>
                            <HeaderStyle Width="70px" />
                        </asp:TemplateField>
                        <asp:CheckBoxField DataField="IsRecommend" HeaderText="推荐">
                            <HeaderStyle Width="70px" />
                        </asp:CheckBoxField>
                        <asp:TemplateField HeaderText="备注">
                            <InsertItemTemplate>
                                <asp:TextBox ID="TextBoxMemo" runat="server" Height="100px" Text='<%# Bind("Memo") %>'
                                    TextMode="MultiLine" Width="800px"></asp:TextBox>
                            </InsertItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="LabelMemo" runat="server" Text='<%# Bind("Memo") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle Width="70px" />
                        </asp:TemplateField>
                        <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                    </Fields>
                    <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                </asp:DetailsView>
            </td>
        </tr>
        <tr>
            <td align="center">
                <%-- 显示现有机票，并提供编辑和删除记录的功能，通过将各控件绑定到数据表各字段实现 --%>
                <asp:GridView DataKeyNames="FlightNumber,DepartDatetime" ID="GridViewTickets" runat="server"
                    DataSourceID="SqlDataSourceTickets" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False"
                    AutoGenerateDeleteButton="True" AutoGenerateEditButton="True" Caption="现有机票"
                    CellPadding="4" ForeColor="#333333" GridLines="None" 
                    Style="text-align: center" 
                    onrowcancelingedit="GridViewTickets_RowCancelingEdit" 
                    onrowupdating="GridViewTickets_RowUpdating">
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                    <Columns>
                        <asp:TemplateField HeaderText="航班号" SortExpression="FlightNumber">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBoxFlightNumber" runat="server" Text='<%# Bind("FlightNumber") %>'
                                    Width="70px"></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="LabelFlightNumber" runat="server" Text='<%# Bind("FlightNumber") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle Width="50px" />
                            <ItemStyle Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="起点" 
                            SortExpression="DepartDatetime,DepartCity,DepartAirport">
                            <EditItemTemplate>
                                出发城市<br />
                                <asp:DropDownList ID="DropDownListDepartCity" runat="server" DataSourceID="SqlDataSourceCities"
                                    DataTextField="City" DataValueField="City" OnSelectedIndexChanged="DropDownListDepartCity_SelectedIndexChanged"
                                    SelectedValue='<%# Bind("DepartCity") %>' AutoPostBack="True" Width="150px">
                                </asp:DropDownList>
                                <br />
                                出发机场<br />
                                <asp:DropDownList ID="DropDownListDepartAirport" runat="server" DataTextField="Name"
                                    DataValueField="Name" SelectedValue='<%# Bind("DepartAirport") %>' OnPreRender="DropDownListDepartAirport_PreRender"
                                    DataSourceID="SqlDataSourceAirports" Width="150px">
                                </asp:DropDownList>
                                <br />
                                出发时间<br />
                                <asp:TextBox ID="TextBoxDepartDatetime" runat="server" Text='<%# Bind("DepartDatetime") %>'
                                    Width="150px"></asp:TextBox>
                            </EditItemTemplate>
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
                            <EditItemTemplate>
                                抵达城市<br />
                                <asp:DropDownList ID="DropDownListArrivalCity" runat="server" AutoPostBack="True"
                                    DataSourceID="SqlDataSourceCities" DataTextField="City" DataValueField="City"
                                    OnSelectedIndexChanged="DropDownListArrivalCity_SelectedIndexChanged" SelectedValue='<%# Bind("ArrivalCity") %>'
                                    Width="150px">
                                </asp:DropDownList>
                                <br />
                                抵达机场<br />
                                <asp:DropDownList ID="DropDownListArrivalAirport" runat="server" DataTextField="Name"
                                    DataValueField="Name" OnPreRender="DropDownListArrivalAirport_PreRender" SelectedValue='<%# Bind("ArrivalAirport") %>'
                                    DataSourceID="SqlDataSourceAirports" Width="150px">
                                </asp:DropDownList>
                                <br />
                                抵达时间<br />
                                <asp:TextBox ID="TextBoxArrivalDatetime" runat="server" Text='<%# Bind("ArrivalDatetime") %>'
                                    Width="150px"></asp:TextBox>
                            </EditItemTemplate>
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
                            <EditItemTemplate>
                                <asp:DropDownList ID="DropDownListModelName" runat="server" DataSourceID="SqlDataSourceModels"
                                    DataTextField="Name" DataValueField="Name" SelectedValue='<%# Bind("ModelName") %>'
                                    Width="100px">
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="LabelModelName" runat="server" Text='<%# Bind("ModelName") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle Width="50px" />
                            <ItemStyle Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="机票信息" 
                            SortExpression="CurrentPrice,OriginalPrice,Amount,SoldAmount">
                            <EditItemTemplate>
                                原始票价<br />
                                <asp:TextBox ID="TextBoxOriginalPrice" runat="server" Text='<%# Bind("OriginalPrice") %>'
                                    Width="50px"></asp:TextBox>
                                元<br />当前票价<br />
                                <asp:TextBox ID="TextBoxCurrentPrice" runat="server" Text='<%# Bind("CurrentPrice") %>'
                                    Width="50px"></asp:TextBox>
                                元<br />合计票数<br />
                                <asp:TextBox ID="TextBoxAmount" runat="server" Text='<%# Bind("Amount") %>' Width="50px"></asp:TextBox>
                                张<br />售出票数<br />
                                <asp:TextBox ID="TextBoxSoldAmount" runat="server" Text='<%# Bind("SoldAmount") %>'
                                    Width="50px"></asp:TextBox>
                                张
                            </EditItemTemplate>
                            <ItemTemplate>
                                原价:
                                <asp:Label ID="LabelOriginalPrice" runat="server" Text='<%# Bind("OriginalPrice") %>'></asp:Label>
                                元<br />现价:
                                <asp:Label ID="LabelCurrentPrice" runat="server" Text='<%# Bind("CurrentPrice") %>'></asp:Label>
                                元<br />票数:
                                <asp:Label ID="LabelAmount" runat="server" Text='<%# Bind("Amount") %>'></asp:Label>
                                张<br />售出:
                                <asp:Label ID="LabelSoldAmount" runat="server" Text='<%# Bind("SoldAmount") %>'></asp:Label>
                                张
                            </ItemTemplate>
                            <HeaderStyle Width="100px" />
                            <ItemStyle Width="100px" />
                        </asp:TemplateField>
                        <asp:CheckBoxField DataField="IsRecommend" HeaderText="推荐" 
                            SortExpression="IsRecommend">
                            <HeaderStyle Width="50px" Wrap="False" />
                            <ItemStyle Width="50px" />
                        </asp:CheckBoxField>
                        <asp:TemplateField HeaderText="备注" SortExpression="Memo">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBoxMemo" runat="server" Height="100px" Text='<%# Bind("Memo") %>'
                                    TextMode="MultiLine" Width="150px"></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="LabelMemo" runat="server" Text='<%# Bind("Memo") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle Width="100px" />
                            <ItemStyle Width="100px" />
                        </asp:TemplateField>
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
                        尚未添加任何机票
                    </EmptyDataTemplate>
                </asp:GridView>
            </td>
        </tr>
        <tr>
            <td align="center">
                <asp:Button ID="ButtonDeleteExpired" runat="server" Text="删除所有过期机票" 
                    onclick="ButtonDeleteExpired_Click" />
            </td>
        </tr>
    </table>
</asp:Content>
