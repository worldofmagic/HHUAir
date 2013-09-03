<%-- 发生未知错误时跳转到的页面 --%>
<%@ Page Title="错误 - 纸飞机航空公司" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="HHUAir.Others.Error" %>
<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<p>对不起，发生未知错误！</p>
    <p>请<a href="#" title="" onclick="history.go(-2);">返回上一页</a>，检查您的操作是否正确！</p>
</asp:Content>
