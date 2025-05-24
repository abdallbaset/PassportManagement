<%@ Page Title="" Language="C#" MasterPageFile="~/Admin Main Interface.master" AutoEventWireup="true" CodeFile="Modify user data.aspx.cs" Inherits="Modify_user_data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
 
    SqlConnection con = new SqlConnection("");

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGridView(); // لما تتحمل الصفحة أول مره GridView  بتربط البيانات ب  
        }
    }

    //GridView  دالة تجي في البيانات وتربطها بـ 
    protected void BindGridView()
    {
        string query = "SELECTاسم عمود بريد الكتروني  ,اسم عمود كلمة المرو   FROM اسم جدول";
        SqlDataAdapter da = new SqlDataAdapter(query, con);
        DataTable dt = new DataTable();
        da.Fill(dt);
        GridView1.DataSource = dt;
        GridView1.DataBind();
    }

    // تفعيل وضع التعديل
    protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView1.EditIndex = e.NewEditIndex; // تفعيل وضع التعديل
        BindGridView(); // إعادة ربط البيانات
    }

    // تحديث البيانات
    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            int UserId  = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value); // تجيب في المفتاح الأساسي
            TextBox txtEmail = (TextBox)GridView1.Rows[e.RowIndex].FindControl("txtEmail");
            TextBox txtPass = (TextBox)GridView1.Rows[e.RowIndex].FindControl("txtPass");
           

            string query = "UPDATE اسم الجدول SET  اسم عمود بريد الكتروني = @Email, اسم عمود كلمة المرور = @Pass";
            SqlCommand cmd = new SqlCommand(query, con);
        
            cmd.Parameters.AddWithValue("@Email", txtEmail.Text);
            cmd.Parameters.AddWithValue("@Pass", txtPass.Text);
          

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            GridView1.EditIndex = -1; // إلغاء وضع التعديل
            BindGridView(); // إعادة ربط البيانات
            Labe_maseg.Text = "تم تحديث البيانات بنجاح!";
        }
        catch (Exception ex)
        {
            Labe_maseg.Text = "حدث خطأ: " + ex.Message;
        }
    }

    // إلغاء التعديل
    protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView1.EditIndex = -1; // إلغاء وضع التعديل
        BindGridView(); // إعادة ربط البيانات
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
            margin-bottom:100px !important;
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

       
        .edit-button {
            background-color: #152d52;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }

        .update-button {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }

        .cancel-button {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }
         .Search container {
          
            text-align:right;
         }
        .BtnResearch{
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
         .BatnResearch:hover {
             background-color: #b68e54;
         }
        .research{
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
    </style>

   

    
     <form id="form1" runat="server">
         <div class="Search container">
                <asp:Button ID="Button1" runat="server" CssClass="BtnResearch" Text="بحث" OnClick="Button1_Click" />
                <asp:TextBox ID="TextBox1" runat="server" CssClass="research"  placeholder="ادخل البريدالكتروني"></asp:TextBox>
         </div>

        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="table" GridLines="None" DataKeyNames="User_id" AllowPaging="True"
            PageSize="6" OnRowEditing="GridView1_RowEditing" OnRowUpdating="GridView1_RowUpdating" OnRowCancelingEdit="GridView1_RowCancelingEdit" OnPageIndexChanging="GridView1_PageIndexChanging">
            <Columns>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="btnEdit" runat="server" Text="تعديل" CommandName="Edit" CssClass="edit-button" />
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:Button ID="btnUpdate" runat="server" Text="حفظ" CommandName="Update" CssClass="update-button" />
                        <asp:Button ID="btnCancel" runat="server" Text="إلغاء" CommandName="Cancel" CssClass="cancel-button" />
                    </EditItemTemplate>
                </asp:TemplateField>

             
                <asp:TemplateField HeaderText="كلمة المرور">
                    <ItemTemplate>
                        <%# Eval("اسم عمود كلمة المرور") %>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtPass" runat="server" Text='<%# Bind("اسم عمود كلمة المرور") %>' />
                    </EditItemTemplate>
                </asp:TemplateField>
               
                <asp:TemplateField HeaderText="البريد الإلكتروني">
                    <ItemTemplate>
                        <%# Eval("اسم عمودالبريدالكتروني") %>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("اسم عمودالبريدالكتروني") %>' />
                    </EditItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
      
        <asp:Label ID="Labe_maseg" runat="server"  CssClass="maseeg"></asp:Label>
         </form>

     
</asp:Content>

