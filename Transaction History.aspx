<%@ Page Title="" Language="C#" MasterPageFile="~/Admin Main Interface.master" AutoEventWireup="true" CodeFile="Transaction History.aspx.cs" Inherits="Transaction_History" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">
protected void Page_Load(object sender, EventArgs e)
{
    if (!IsPostBack)
    {
        
       ddlActionType.Items[0].Attributes.Add("disabled", "true"); // dropDowinlist تعطيل الخيار الأول في 
    }
}




</script>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
         <style>
      
        form{
            margin-top: 100px;
           max-width:70%;
           margin:100px auto;
           font-family:Tajawal;
        }
        table {
            width: 100%;
            border-collapse: collapse;
          
        }

        table th, table td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: center;
        }

        table th {
            background-color: #152d52;
            color: white;
        }

    
           .bttnSearch {
         font-family:Tajawal;
         font-weight:700;
         float:right;
         margin-bottom:20px;
         width:70px;
         height:35px;
         border-radius:5px;
         background-color:#cca56e;
         color:#ffffff;
         border:none;
                       }
          .Search{
          font-family:Tajawal;
          font-weight:900;
          height:30px;
          float:right;
          width:230px;
          border-radius:5px;
          outline:none;
          border:none;
          margin-right:20px;
          text-align:right;

          }
          .bttnSearch:hover {
    background-color: #b68e54;
}
             .ddlActionType {
                 font-family:Tajawal;
                  font-weight:900;
                  float:right;
                  margin-right:20px;
                  width:100px;
                    height:30px;

             }
 
    </style>
     <form id="form1" runat="server">
        

                   <asp:Button ID="BtnSearch" runat="server" Text="بحث" CssClass="bttnSearch" Visible="true" OnClick="BtnSearch_Click" />
                   <asp:TextBox ID="ReasonForSearch" runat="server" CssClass="Search " Visible="true" placeholder="ادخل البريد الكتروني"></asp:TextBox>
                   <asp:DropDownList ID="ddlActionType" runat="server" CssClass="ddlActionType">
                       <asp:ListItem Selected="True">نوع الإجراء</asp:ListItem>
                       <asp:ListItem>قبول</asp:ListItem>
                       <asp:ListItem>رفض</asp:ListItem>
                   </asp:DropDownList>

          <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" CssClass="table" 
              GridLines="None" DataKeyNames="Log_id" AllowPaging="True" ShowHeader="True" PageSize="6"
              OnPageIndexChanging="GridView1_PageIndexChanging">

            <Columns>
                              <asp:BoundField DataField="ActionExecutionDate" HeaderText="تاريخ تنفيذ الإجراء" />
                              <asp:BoundField DataField="ActionType" HeaderText="نوع الإجراء" />
                              <asp:BoundField DataField="Email" HeaderText="البريد الإلكتروني" />
                              <asp:BoundField DataField="UserID" HeaderText="رقم المستخدم" />
            </Columns>
        </asp:GridView>
         </form>
</asp:Content>

