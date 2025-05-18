<%@ Page Title="" Language="C#" MasterPageFile="~/Admin Main Interface.master" AutoEventWireup="true" CodeFile="Admin requests.aspx.cs" Inherits="Admin_requests" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    // تعريف الاتصال بقاعدة البيانات
    SqlConnection con = new SqlConnection("");

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGridView(); // ربط البيانات بـ GridView عند تحميل الصفحة لأول مرة
        }
    }

    // GridView دالة لجلب البيانات وربطها بـ 
    protected void BindGridView()
    {
        string query = " ";//استعلام لجلب البيانات الطلبات من قاعدة البيانات
        SqlDataAdapter da = new SqlDataAdapter(query, con);
        DataTable dt = new DataTable();
        da.Fill(dt);
        GridView1.DataSource = dt;
        GridView1.DataBind();
    }

  

 
    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {

            BindGridView(); // إعادة ربط البيانات
            Labe_maseg.Text = "تم  قبول الطلب ";
        }
        catch (Exception ex)
        {
            Labe_maseg.Text = "حدث خطأ: " + ex.Message;
        }
    }

    // الترحيل (Paging)
    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex; // تغيير الصفحة
        BindGridView(); // إعادة ربط البيانات
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

        .maseeg {
            display:block;
            margin-top: 10px;
            font-weight: bold;
            color: #28a745;
            text-align:center;
           
        }
        .acceptance-button {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }

        .Rejection-button {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }
           .bttnReason {
         font-family:Tajawal;
         font-weight:700;
         float:right;
         margin-bottom:20px;
         width:70px;
         height:35px;
         border-radius:5px;
         background-color:#152d52;
         color:#ffffff;
         border:none;
                       }
          .ReasonField{
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
          .Reamaseeg{
           font-family:Tajawal;
           font-weight: bold;
           color: #ff0000;
           float:right;
           margin-right:20px;
          }
 
    </style>
     <form id="form1" runat="server">
        

        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="table" GridLines="None" DataKeyNames="Request_id" AllowPaging="True"
            PageSize="6" OnRowEditing="GridView1_RowEditing" OnRowUpdating="GridView1_RowUpdating" OnRowCancelingEdit="GridView1_RowCancelingEdit" OnPageIndexChanging="GridView1_PageIndexChanging" OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
            <Columns>
                <asp:TemplateField HeaderText="الإجراء">
                    <ItemTemplate>
                        <asp:Button ID="btnRejection" runat="server" Text="رفض" CommandName="Rejection" CssClass="Rejection-button" />
                        <asp:Button ID="btnacceptance" runat="server" Text="قبول" CommandName="acceptance" CssClass="acceptance-button" />
                    </ItemTemplate>
                </asp:TemplateField>

                         <asp:BoundField DataField="RequestType" HeaderText="نوع الطلب" />
                         <asp:BoundField DataField="RequestDate" HeaderText="تاريخ تقديم الطلب" />
                         <asp:BoundField DataField="NationalID" HeaderText="رقم الوطني لمقدم الطلب" />
                         <asp:BoundField DataField="RequestID" HeaderText="رقم الطلب" />
                </Columns>
        </asp:GridView>
        <asp:Label ID="Labe_maseg" runat="server"  CssClass="maseeg"></asp:Label>
                   <asp:Button ID="BtnReason" runat="server" Text="إرسال" CssClass="bttnReason" Visible="False" />
                   <asp:TextBox ID="ReasonForReection" runat="server" CssClass="ReasonField  " Visible="False"></asp:TextBox>
                   <asp:Label ID="Label1" runat="server" Text="تم رفض الطلب" CssClass="Reamaseeg" Visible="False"></asp:Label>
         </form>
</asp:Content>

