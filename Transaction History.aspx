<%@ Page Title="" Language="C#" MasterPageFile="~/Admin Main Interface.master" AutoEventWireup="true" CodeFile="Transaction History.aspx.cs" Inherits="Transaction_History" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">
    SqlConnection conn = new SqlConnection("Server=msi;Database=the_main;Integrated Security=True");
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            ddlActionType.Items[0].Attributes.Add("disabled", "true"); // dropDowinlist تعطيل الخيار الأول في 
        }
        string  query = "SELECT  l.creat_at as 'تاريخ تنفيد الاجراء',l.action_type as'نوع الاجراء',  u.email as'بريد الالكتروني',l.user_id as 'رقم المستخدم' FROM local_history l INNER JOIN users u ON l.user_id = u.user_id";
        SqlCommand cmd = new SqlCommand(query, conn);
        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        adapter.Fill(dt);
        gvReport.DataSource = dt;
        gvReport.DataBind();
    }

    protected void BtnSearch_Click(object sender, EventArgs e)

    { string query = "";

        if (String.IsNullOrEmpty(ReasonForSearch.Text))
        {  query = "SELECT  l.creat_at as 'تاريخ تنفيد الاجراء',l.action_type as'نوع الاجراء',  u.email as'بريد الالكتروني',l.user_id as 'رقم المستخدم' FROM local_history l INNER JOIN users u ON l.user_id = u.user_id WHERE l.action_type = @action ";


        }

        else if (ddlActionType.SelectedValue != "0")
        {
            query = "SELECT  l.creat_at as 'تاريخ تنفيد الاجراء',l.action_type as'نوع الاجراء',  u.email as'بريد الالكتروني',l.user_id as 'رقم المستخدم' FROM local_history l INNER JOIN users u ON l.user_id = u.user_id WHERE u.email = @aemail AND l.action_type = @action ";
        }
        else
        {
             query = "SELECT  l.creat_at as 'تاريخ تنفيد الاجراء',l.action_type as'نوع الاجراء',  u.email as'بريد الالكتروني',l.user_id as 'رقم المستخدم' FROM local_history l INNER JOIN users u ON l.user_id = u.user_id WHERE u.email = @aemail ";
        }


        using (SqlConnection conn = new SqlConnection("Server=msi;Database=the_main;Integrated Security=True"))
        {
            try
            {

                conn.Open();

                using (SqlCommand dat = new SqlCommand(query, conn))
                {
                    dat.Parameters.AddWithValue("@aemail", ReasonForSearch.Text.Trim());
                    if (ddlActionType.SelectedValue != "2")
                    {
                        dat.Parameters.AddWithValue("@action", "قبول");
                    }
                    else { dat.Parameters.AddWithValue("@action", "رفض");}

                    using (SqlDataAdapter adapter = new SqlDataAdapter(dat))
                    {
                        DataTable dta = new DataTable();
                        adapter.Fill(dta);

                        if (dta.Rows.Count > 0)
                        {
                            gvReport.DataSource = dta;
                            gvReport.DataBind();
                        }
                        else
                        {
                            gvReport.DataSource = null;
                            gvReport.DataBind();
                            // يمكن عرض رسالة تفيد بعدم وجود بيانات
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // عرض الخطأ للمساعدة في تحديد المشكلة
                Response.Write("Error: " + ex.Message);
            }
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
                  outline:none;

             }
 
    </style>
     <form id="form1" runat="server">
        

                   <asp:Button ID="BtnSearch" runat="server" Text="بحث" CssClass="bttnSearch" Visible="true" OnClick="BtnSearch_Click" />
                   <asp:TextBox ID="ReasonForSearch" runat="server" CssClass="Search " Visible="true" Text="" placeholder="ادخل البريد الكتروني"></asp:TextBox>
                   <asp:DropDownList ID="ddlActionType" runat="server" CssClass="ddlActionType" OnSelectedIndexChanged="ddlActionType_SelectedIndexChanged">
                       <asp:ListItem Selected="True" Value="0">نوع الإجراء</asp:ListItem>
                       <asp:ListItem Value="1" Text="قبول"></asp:ListItem>
                       <asp:ListItem Value="2" Text="رفض"></asp:ListItem>
                   </asp:DropDownList>

       
               <asp:GridView ID="gvReport" runat="server" AutoGenerateColumns="true" OnSelectedIndexChanged="gvReport_SelectedIndexChanged" >
                  </asp:GridView>



         </form>
</asp:Content>

