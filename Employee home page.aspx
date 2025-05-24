<%@ Page Title="" Language="C#" MasterPageFile="~/Employee interface.master" AutoEventWireup="true" CodeFile="Employee home page.aspx.cs" Inherits="Employee_home_page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <style>
        .welcome-box {
    width: 50%;
    margin: 100px auto;
    padding: 20px;
    background-color: #f8f9fa;
    border: 1px solid #ccc;
    text-align: center;
    border-radius: 10px;
    box-shadow: 2px 2px 10px rgba(0,0,0,0.2);
}
        p{
             display:inline;
        }
      
    </style>
    <asp:Panel ID="pnlWelcome" runat="server" CssClass="welcome-box">
    <h2>مرحبًا بكم في منظومة جواز السفر</h2>
    <p><strong>Employee:</strong></p>
        <asp:Label ID="EmailMaseeg" runat="server"  CssClass="Maseeg" Text=""></asp:Label>
</asp:Panel>
</asp:Content>

